require 'rspec/autorun'
require './lib/crypto_client'

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
