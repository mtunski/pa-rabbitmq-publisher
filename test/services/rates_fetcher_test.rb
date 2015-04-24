require 'test_helper'

class RatesFetcherTest < ActiveSupport::TestCase
  include OpenExchangeStub

  setup do
    @rates_fetcher = RatesFetcher.new
    @response_mock = stub_openexchange_api_request
  end

  def test_fetches_and_saves_rates_if_none_present_in_the_database
    assert_difference 'Currency.count' do
      @rates_fetcher.call
    end
    assert_equal @response_mock['rates'], Currency.latest.rates
  end

  def test_fetches_and_saves_rates_if_latest_rates_older_than_1_hour
    Currency.create!(created_at: 65.minutes.ago)

    assert_difference 'Currency.count' do
      @rates_fetcher.call
    end
    assert_equal @response_mock['rates'], Currency.latest.rates
  end

  def test_returns_latest_rates_from_the_database_if_not_older_than_1_hour
    assert_equal Currency.create!, @rates_fetcher.call
  end
end
