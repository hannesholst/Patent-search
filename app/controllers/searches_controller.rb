class SearchesController < ApplicationController
  helper :searches
  include SearchesHelper
  
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
    page = params[:page] || 1
    @page = page.to_i
    logger.debug "showing page: #{@page}"
    page_start = ( (@page-1) * 25 ) + 1
    page_end = ( (@page-1) * 25) + 25

    if params.has_key?(:query)
       query_string = params[:query] || ""
       @search = Search.new
    else
      @search = Search.new params[:search]
      query_string = @search.query
    end

    if query_string.empty?
      flash[:error] = "Empty Search"
      @search.last_query = "empty query"
      @search.hits = 0
      @search.response_time = 0
      @search.range = "0"
      return
    end
    
    begin
      #http://ops.epo.org/2.6.2/rest-services/published-data/search?q=applicant%3DIBM
      url_encoded_string = CGI::escape(query_string)
      resource = RestClient::Resource.new \
        "http://ops.epo.org/2.6.2/rest-services/published-data/search/biblio?q=#{url_encoded_string}&range=#{page_start}-#{page_end}"
      @search.response = resource.get
      #logger.debug @search.response
      #logger.debug "Api returned: #{@search.response.code}"
    rescue RestClient::BadRequest
      @search.last_query = query_string
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
      @search.range_start = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['begin']
      @search.range_end = @doc['ops:world_patent_data']['ops:biblio_search']['ops:range']['end']
      @search.range = "#{@search.range_start} to #{@search.range_end}"
      publications = get_publications
      @search.results = publications if publications
      #page(params[:page]).per(5)
      get_images()
    end

    #Downloading images for patents
    #GET http://ops.epo.org/2.6.2/rest-services/published-data/publication/epodoc/EP1000000.A1/images
    #GET http://ops.epo.org/2.6.2/rest-services/published-data/publication/docdb/US.2011074386.A1/images


    #resource = RestClient::Resource.new \
    #"http://ops.epo.org/2.6.2/rest-services/published-data/publication/docdb/US.2011074386.A1/images"
    #response = resource.get
    #response_hash = Crack::XML.parse (response)

      varstop = 1

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @search.response}
    end
  end

  
end
