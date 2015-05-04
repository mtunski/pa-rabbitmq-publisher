namespace :rabbit do
  desc 'Prepares RabbitMQ queues and exchanges for the system.'
  task setup: :environment do
    Bunny.new.tap do |connection|
      channel = connection.start.create_channel

      currencies_fanout = channel.fanout('currencies.fanout', durable: true)
      1.upto(3) { |i| channel.queue("currencies.queue_#{i}", durable: true).bind(currencies_fanout) }

      channel.queue('currencies.acknowledgements', durable: true).bind(
        channel.direct('currencies.direct', durable: true),
        routing_key: 'acknowledgements'
      )
    end
  end
end
