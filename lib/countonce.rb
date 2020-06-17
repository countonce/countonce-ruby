require "httparty"
require "concurrent-ruby"

PingResult = Struct.new(:json)
QueryResult = Struct.new(:json)

class CountOnce
  include Concurrent::Async

  DEFAULT_DOMAIN = "countapi.com"
  DEFAULT_SCHEMA = "https"

  attr_accessor :account_id
  attr_accessor :auth_token
  attr_accessor :url

  def initialize(credentials = {})
    @account_id = credentials[:account_id]
    @auth_token = credentials[:auth_token]

    api_protocol = ENV.key?("_API_PROTOCOL") ? ENV["_API_PROTOCOL"] : DEFAULT_SCHEMA
    api_domain = ENV.key?("_API_DOMAIN") ? ENV["_API_DOMAIN"] : DEFAULT_DOMAIN
    
    @url = "#{api_protocol}://#{credentials[:account_id]}.#{api_domain}"
  end

  def ping(ping_options = {})
    url_params = {}
    url_params["key"] = ping_options[:key] || "",
    url_params["unique_value"] = ping_options[:unique_value] || ""
    
    headers = {}
    headers["Content-Type"] = "application/x-www-form-urlencoded; charset=UTF-8" 
    headers["Authorization"] = "Bearer #{@auth_token}" if @auth_token
  
    if ping_options[:attributes]
      ping_options[:attributes].each {|key, value| url_params["attributes[#{key}]"] = value}
    end

    url_params["revenue"] = ping_options[:revenue] if ping_options[:revenue]
    url_params["timezone"] = ping_options[:timezone] if ping_options[:timezone]

    response = HTTParty.post(
      @url + "/ping",
      :body => url_params,
      :headers => headers,
      :verify => false
    )

    PingResult.new(response.parsed_response)
  end

  def query(key_name, query_type, query_options = {}, iterator = nil)
    url_params = {}
    url_params["iterator"] = iterator if iterator

    headers = {}
    headers["Authorization"] = "Bearer #{@auth_token}" if @auth_token

    if query_options[:filter]
      query_options[:filter].each {|key, value| url_params["filter[#{key}]"] = value}
    end

    if query_options[:include]
      if query_options[:include].is_a? Array
        includes.each {|val| url_params["include[]"] = val}
      else
        url_params["include"] = query_options[:include]
      end
    end

    url_params["start_date"] = query_options[:start_date] if query_options[:start_date]
    url_params["end_date"] = query_options[:start_date] if query_options[:end_date]
    url_params["range"] = query_options[:start_date] if query_options[:range]
    url_params["prev_start_date"] = query_options[:start_date] if query_options[:prev_start_date]
    url_params["prev_end_date"] = query_options[:start_date] if query_options[:prev_end_date]
    url_params["prev_range"] = query_options[:start_date] if query_options[:prev_date]

    response = HTTParty.get(
      "#{@url}/#{query_type}/#{key_name}/#{query_options[:metric] || 'daily'}",
      :query => url_params,
      :headers => headers,
      :verify => false
    )

    return QueryResult.new(response.parsed_response)
  end

  def getUniques(key_name, query_options = {}, iterator = nil)
    self.query(key_name, 'uniques', query_options, iterator)
  end

  def getCounts(key_name, query_options = {}, iterator = nil)
    self.query(key_name, 'counts', query_options, iterator)
  end

  def getRevenue(key_name, query_options = {}, iterator = nil)
    self.query(key_name, 'revenue', query_options, iterator)
  end

  def getCombined(key_name, query_options = {}, iterator = nil)
    self.query(key_name, 'combined', query_options, iterator)
  end
end
