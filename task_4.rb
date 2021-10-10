require 'rspec/autorun'
require './lib/crypto_client'

class TaskFour
  attr_reader :currency, :reference_crypto

  def initialize(currency:, reference_crypto: 'BTC')
    @currency = currency
    @reference_crypto = reference_crypto
  end

  def run
    pair = CryptoClient.new('currencies/ticker', ids: ids).get

    price(pair.first) / price(pair.last)
  end

  private

  def ids
    [currency, reference_crypto].join(',')
  end

  def price(crypto)
    crypto.fetch('price').to_f
  end
end

RSpec.describe 'TaskFour' do
  let(:task) { TaskFour.new(currency: 'BTT', reference_crypto: 'AXS') }
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
    expect(result).to eq(60.18202333990751)
  end
end
