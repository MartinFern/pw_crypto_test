require 'uri'
require 'net/http'
require 'json'
require 'rspec/autorun'
require 'dotenv/load'
require 'pry'

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

class TaskOne
  attr_reader :tickers

  def initialize(tickers = [])
    @tickers = tickers
  end

  def run
    CryptoClient
      .new('currencies/ticker', ids: tickers.join(','))
      .get
  end
end

RSpec.describe 'TaskOne' do
    let(:task) { TaskOne.new(['BTT', 'AXS']) }
    let(:result) { task.run }

  it 'returns full payload, given tickers' do
    expect(result).to be_a(Array)
    expect(result).to have_attributes(size: 2)

    expect(result.dig(0, 'id')).to eq('BTT')
    expect(result.dig(1, 'id')).to eq('AXS')
  end
end
