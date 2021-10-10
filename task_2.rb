require 'rspec/autorun'
require './lib/crypto_client'

class TaskTwo
  attr_reader :tickers, :fields

  def initialize(tickers = [], fields = [])
    @tickers = tickers
    @fields = fields
  end

  def run
    CryptoClient
      .new('currencies/ticker', ids: tickers.join(','))
      .get
      .map { |crypto| crypto.slice(*fields) }
  end
end

RSpec.describe 'TaskTwo' do
  let(:task) { TaskTwo.new(['BTT', 'AXS'], ['id', 'status']) }
  let(:result) { task.run }

  before do
    allow(CryptoClient).to receive(:new).and_return(double(get: [
      {
        'id' => 'BTT',
        'status' => 'active',
        'price' => '0.0041642670'
      },
      {
        'id' => 'AXS',
        'status' => 'dead',
        'price' => '0.000069194533'
      }
    ]))
  end

  it 'returns selected payload, given tickers' do
    expect(result).to eq([
      {
        'id' => 'BTT',
        'status' => 'active'
      },
      {
        'id' => 'AXS',
        'status' => 'dead'
      }
    ])
  end
end
