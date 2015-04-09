require 'test_helper'

class RatesFetcherTest < ActiveSupport::TestCase
  setup do
    @rates_fetcher = RatesFetcher.new
    stub_openexchange_api_request
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

  private

  def stub_openexchange_api_request
    @response_mock = {
      'rates' => {
        'PLN' => 3.729895,
        'EUR' => 0.928687,
        'CHF' => 0.968524
      }
    }

    stub_request(:get, RatesFetcher::OPENEXCHANGE_API_URL).to_return(
      status: 200,
      body:   @response_mock.to_json
    )
  end
end
