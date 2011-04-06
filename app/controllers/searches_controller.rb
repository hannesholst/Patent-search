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
        "http://ops.epo.org/2.6.2/rest-services/published-data/search?q=#{url_encoded_string}"
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

      logger.debug @doc_2.inspect

      @search.last_query = @doc['ops:world_patent_data']['ops:biblio_search']['ops:query']
      @search.hits = @doc['ops:world_patent_data']['ops:biblio_search']['total_result_count']
      response_elapsed_time = @doc['ops:world_patent_data']['ops:meta']['value']
      @search.response_time = response_elapsed_time.to_f / 1000 if response_elapsed_time
      range_start = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['begin']
      range_end = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['end']
      @search.range = "#{range_start} to #{range_end}"
    end

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @search.response}
    end
  end
end
