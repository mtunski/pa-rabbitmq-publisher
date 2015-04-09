require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  def test_latest_returns_the_last_currency_ordered_by_created_date
    c1 = Currency.create!(created_at: 10.minutes.ago)
    c2 = Currency.create!(created_at: 1.hour.ago)
    c3 = Currency.create!(created_at: 1.minute.ago)
    c4 = Currency.create!(created_at: 1.day.ago)

    assert_equal c3, Currency.latest
  end
end
