require 'test_helper'
require 'mocha/mini_test'

class AcknowledgementsWorkerTest < ActiveSupport::TestCase
  setup do
    @acknowledgements_worker = AcknowledgementsWorker.new
    @currency                = Currency.create!
  end

  def test_updates_the_proper_acknowledgement_column
    refute @currency.consumer1_ack
    refute @currency.consumer2_ack
    refute @currency.consumer3_ack

    @acknowledgements_worker.work({id: 3, uuid: @currency.id}.to_json)
    @currency.reload

    refute @currency.consumer1_ack
    refute @currency.consumer2_ack
    assert @currency.consumer3_ack
  end

  def test_acks_when_successfull
    @acknowledgements_worker.expects(:ack!).once

    @acknowledgements_worker.work({id: 3, uuid: @currency.id}.to_json)
  end

  def test_requeues_up_to_5_times_then_rejects
    order = sequence('order')

    @acknowledgements_worker.expects(:requeue!).in_sequence(order).times(5)
    @acknowledgements_worker.expects(:reject!).in_sequence(order).once
    @acknowledgements_worker.expects(:ack!).never

    6.times { @acknowledgements_worker.work({id: 3, uuid: 'nope.'}.to_json) }
  end
end
