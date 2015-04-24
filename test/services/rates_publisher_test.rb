require 'test_helper'
require 'mocha/mini_test'
require 'bunny_mock'

class RatesFetcherTest < ActiveSupport::TestCase
  include OpenExchangeStub

  setup do
    @rates_publisher = RatesPublisher.new
    stub_openexchange_api_request
    stub_rabbitmq_setup
  end

  def test_publishes_currencies_to_all_the_queues
    @rates_publisher.call

    response = ({
      uuid:  Currency.last.id,
      rates: Currency.last.rates
    }).to_json

    assert_equal [response], @currencies_queue_1.messages
    assert_equal [response], @currencies_queue_2.messages
    assert_equal [response], @currencies_queue_3.messages
  end

  private

  def stub_rabbitmq_setup
    mock_connection     = BunnyMock.new
    channel             = mock_connection.create_channel

    currencies_fanout   = channel.fanout('currencies.fanout')
    @currencies_queue_1 = mock_connection.queue("currencies.queue_1")
    @currencies_queue_2 = mock_connection.queue("currencies.queue_2")
    @currencies_queue_3 = mock_connection.queue("currencies.queue_3")

    [@currencies_queue_1, @currencies_queue_2, @currencies_queue_3].each do |queue|
      queue.bind(currencies_fanout)
    end

    mock_connection.stubs(:create_channel).returns(channel)
    @rates_publisher.stubs(:connection).returns(mock_connection)
  end
end
