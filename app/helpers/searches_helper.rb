require "active_support"
require 'rubygems'
require 'sourcify'

module SearchesHelper
  class SearchesElementNotFound < StandardError ;end

  #Returns nil when the element is not defined
  def retrieve_element &block
    @element_valid = true
    begin
      result = block.call
      raise if result.nil?
      result
    rescue
      logger.debug "Element not found in #{block.to_source(:strip_enclosure => true)}"
      @element_valid = false
      return nil
    end    
  end

  def element_invalid?
    not @element_valid
  end

  def element_valid?
    @element_valid
  end

  def get_publications
    #This works for simple query without biblio
    #resultsHash = @doc['ops:world_patent_data']['ops:biblio_search']['ops:search_result']['ops:publication_reference']

    result_search = retrieve_element {
       @doc['ops:world_patent_data']['ops:biblio_search']['exchange_documents']
    }

    return nil if element_invalid?
    
    #Case for a single document returned in the search
    results_array = nil
    if result_search.is_a? Hash
      #Wrap the single result in an array to make it work as the case at the 'else''
      results_array = Array.new
      results_array[0] = result_search
    else
      results_array = result_search
    end

    #can the hash be nul?
    return nil if results_array.nil? or results_array.size == 0

    publication = Array.new
    results_array.each do |document_container|
      pub_element = Hash.new

      pub = retrieve_element {
        document_container['exchange_document']
      }

      pub_element[:id] = if element_valid?
         "#{pub['country']} #{pub['doc_number']} #{pub['kind']}"
      else
        "Not found"
      end

      applicant = retrieve_element {
        #This line does not generate and error when not present - need to investigate
        pub['bibliographic_data']['parties']['applicants']
      }

      logger.debug "No applicants for #{pub_element[:id]}" if element_invalid?
      #logger.debug "returned: #{element_valid?}"

      pub_element[:applicant] = if element_valid?
        first_applicant = retrieve_element {
          applicant['applicant'][0]['applicant_name']['name']
        }
        element_valid? ? first_applicant : "Not found"
      else
        "Not found"
      end

      #Retrieving Priority Date
      priority = retrieve_element {
        pub['bibliographic_data']['priority_claims']['priority_claim']
      }
      pub_element[:priority_date] = if element_valid?
        first_priority = if priority.is_a? Array
          retrieve_element {
            priority[0]['document_id'][0]['date']
          }
          else
          retrieve_element {
            priority['document_id'][0]['date']
          }
        end
        element_valid? ? first_priority : "Not found"
      else
        "Not found"
      end

      publication << pub_element
    end
    publication
  end

  def get_images
    resource = RestClient::Resource.new \
        "http://ops.epo.org/2.6.2/rest-services/published-data/publication/docdb/WO.2011037743.A2/images"
    #2011074394 2011074386 2011078126 2303896 2304908 2011037743
    response = resource.get
    response_hash = Crack::XML.parse (response)
  end

end