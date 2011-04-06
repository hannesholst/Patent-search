class SearchesController < ApplicationController

  def index
    @search = Search.new
    respond_to do |format|
        format.html # index.html.haml
        format.xml  #{ render :text => "hola" }
    end
  end

  def new
  end

  def create
    require 'crack'

    @search = Search.new params[:search]
    begin
      #http://ops.epo.org/2.6.2/rest-services/published-data/search?q=applicant%3DIBM
      url_encoded_string = CGI::escape(@search.query)
      resource = RestClient::Resource.new \
        "http://ops.epo.org/2.6.2/rest-services/published-data/search/biblio?q=#{url_encoded_string}"
      @search.response = resource.get
  #   logger.debug @search.response
  #   logger.debug "Api returned: #{@search.response.code}"
    rescue RestClient::BadRequest
      @search.last_query = @search.query
      @search.hits = 0
      @search.response_time = 0
      @search.range = "0"
      flash[:error] = "Invalid Common Query Language Statement"
    else
      @doc = Crack::XML.parse (@search.response)

      @search.last_query = @doc['ops:world_patent_data']['ops:biblio_search']['ops:query']
      @search.hits = @doc['ops:world_patent_data']['ops:biblio_search']['total_result_count']
      response_elapsed_time = @doc['ops:world_patent_data']['ops:meta']['value']
      @search.response_time = response_elapsed_time.to_f / 1000 if response_elapsed_time
      range_start = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['begin']
      range_end = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['end']
      @search.range = "#{range_start} to #{range_end}"

      #This works for simple query without biblio
      #resultsHash = @doc['ops:world_patent_data']['ops:biblio_search']['ops:search_result']['ops:publication_reference']
      result_search = @doc['ops:world_patent_data']['ops:biblio_search']['exchange_documents']

      #Case for a single document returned in the search
      results_array = nil
      if result_search.is_a? Hash
        results_array = Array.new
        results_array[0] = result_search
      else
        results_array = result_search
      end

      #can the hash be nul?
      if results_array.size > 0 then
        publication = Array.new
        results_array.each do |document_container|
          pub_element = Hash.new

          pub = document_container['exchange_document']
          pub_element[:id] = "#{pub['country']} #{pub['doc_number']} #{pub['kind']}"

          #Retrieving applicants
          #The document might have or not applicants so needs error control.
          applicant = pub['bibliographic_data']['parties']['applicants']
          unless applicant.nil? then
            begin
              first_applicant = applicant['applicant'][0]['applicant_name']['name']

              #Check to do: Assuming this case can exist (inferred from case below)
              #first_applicant = applicant['applicant']['applicant_name']['name']
            rescue
              logger.debug "Nil object reference in applicant claim"
              pub_element[:applicant] = "Not found"
            end

            if first_applicant.nil?
              pub_element[:applicant] = "Not found"
            else
              pub_element[:applicant] = first_applicant
            end
          end

          #Retrieving Priority Date
          priority = pub['bibliographic_data']['priority_claims']['priority_claim']
          unless priority.nil? then

            begin
              if priority.is_a? Array
                first_priority = priority[0]['document_id'][0]['date']
              else
                first_priority = priority['document_id'][0]['date']
              end
            rescue
              logger.debug "Nil object reference in priority claim"
              pub_element[:priority_date] = "Not found"
            end

            if first_priority.nil?
              pub_element[:priority_date] = "Not found"
            else
              pub_element[:priority_date] = first_priority
            end
          end


          publication << pub_element
        end

        @search.results = publication if publication.size > 0
      end
        varstop = 1
    end

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @search.response}
    end
  end

  
end
