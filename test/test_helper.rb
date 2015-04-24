ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end

module OpenExchangeStub
  require 'webmock/minitest'

  private

  def stub_openexchange_api_request
    response_mock = {
      'rates' => {
        'PLN' => 3.729895,
        'EUR' => 0.928687,
        'CHF' => 0.968524
      }
    }

    stub_request(:get, RatesFetcher::OPENEXCHANGE_API_URL).to_return(
      status: 200,
      body:   response_mock.to_json
    )

    response_mock
  end
end
