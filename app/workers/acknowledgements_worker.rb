class AcknowledgementsWorker
  include Sneakers::Worker
  from_queue 'currencies.acknowledgements'

  def initialize
    @retries = 0
  end

  def work(msg)
    acknowledgement = JSON.parse(msg, symbolize_names: true)

    begin
      currency = Currency.find(acknowledgement[:uuid])
    rescue ActiveRecord::RecordNotFound
      return (self.retries += 1) <= 5 ? requeue! : reject!
    end

    consumer_ack = "consumer#{acknowledgement[:id]}_ack"
    currency.update_attribute(consumer_ack, true)
    ack!
  end

  private

  attr_accessor :retries
end
