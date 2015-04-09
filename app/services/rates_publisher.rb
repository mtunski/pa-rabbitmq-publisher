class RatesPublisher
  def initialize
    @rates_fetcher, @connection = RatesFetcher.new, Bunny.new
  end

  def call
    begin
      connection.start
      publish_rates
    ensure
      connection.stop
    end
  end

  private

  attr_reader :rates_fetcher, :connection

  def publish_rates
    fanout   = connection.create_channel.fanout('currencies.fanout')
    currency = rates_fetcher.call

    fanout.publish({
      uuid:  currency.id,
      rates: currency.rates
    }.to_json)
  end
end

