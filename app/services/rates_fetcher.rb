class RatesFetcher
  require 'open-uri'

  def call
    should_fetch? ? fetch_rates : latest_rates
  end

  private

  def latest_rates
    @latest_rates ||= Currency.latest
  end

  def fetch_rates
    response = JSON.parse(open("http://openexchangerates.org/api/latest.json?app_id=#{ENV['OPENEXCHANGE_APP_ID']}").read)
    Currency.create!(rates: response['rates'])
  end

  def should_fetch?
    latest_rates.blank? || latest_rates.created_at < 1.hour.ago
  end
end

