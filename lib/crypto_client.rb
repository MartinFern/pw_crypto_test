require 'uri'
require 'net/http'
require 'json'
require 'dotenv/load'

class CryptoClient
  attr_reader :path, :params

  BASE_URI = "https://api.nomics.com/v1"

  def initialize(path = "", params = {})
    @path = path
    @params = params
  end

  def get
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      JSON.parse(response.body)
    else
      response.body.strip
    end
  end

  private

  def uri
    URI.parse([BASE_URI, path].join('/')).tap do |uri|
      uri.query = query
    end
  end

  def query
    URI.encode_www_form(params.to_a.push(['key', api_key]))
  end

  def api_key
    ENV.fetch('NOMICS_API_KEY')
  end
end
