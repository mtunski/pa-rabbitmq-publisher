class CurrenciesController < ApplicationController
  def latest
    @currency = Currency.latest
  end

  def publish
    publisher.call
    redirect_to action: :latest
  end

  private

  def publisher
    @publisher ||= RatesPublisher.new
  end
end
