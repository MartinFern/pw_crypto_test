require 'rspec/autorun'
require './lib/crypto_client'

class TaskThree
  attr_reader :currency, :reference_fiat

  def initialize(currency:, reference_fiat:)
    @currency = currency
    @reference_fiat = reference_fiat
  end

  def run
    query_params = {
      ids: currency,
      'quote-currency': reference_fiat
    }

    CryptoClient
      .new('currencies/ticker', query_params)
      .get
      .dig(0, 'price')
      .to_f
  end
end

RSpec.describe 'TaskThree' do
  let(:task) { TaskThree.new(currency: 'BTT', reference_fiat: 'EUR') }
  let(:result) { task.run }

  before do
    allow(CryptoClient).to receive(:new).and_return(double(get: [
      {
        'id' => 'BTT',
        'status' => 'active',
        'price' => '0.0041642670'
      }
    ]))
  end

  it 'returns selected payload, given tickers' do
    expect(result).to eq(0.0041642670)
  end
end
