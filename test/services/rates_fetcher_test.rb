require 'test_helper'

class RatesFetcherTest < ActiveSupport::TestCase
  setup do
    @rates_fetcher = RatesFetcher.new
  end

  def test_fetches_rates_if_none_present_in_the_database
    @rates_fetcher.expects(:fetch_rates).returns('fetched')
    assert_equal 'fetched', @rates_fetcher.call
  end

  def test_fetches_rates_if_latest_rates_older_than_1_hour
    Currency.create!(created_at: 65.minutes.ago)

    @rates_fetcher.expects(:fetch_rates).returns('fetched')
    assert_equal 'fetched', @rates_fetcher.call
  end

  def test_returns_latest_rates_from_the_database_if_not_older_than_1_hour
    assert_equal Currency.create!, @rates_fetcher.call
  end
end
