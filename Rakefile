require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :rabbit do
  desc "Prepares RabbitMQ queues and exchanges for the system."
  task :setup => :environment do
    connection = Bunny.new
    connection.start

    channel = connection.create_channel

    currencies_fanout = channel.fanout('currencies.fanout')
    channel.queue('currencies.queue_1').bind(currencies_fanout)
    channel.queue('currencies.queue_2').bind(currencies_fanout)
    channel.queue('currencies.queue_3').bind(currencies_fanout)

    currencies_direct = channel.direct('currencies.direct')
    channel.queue('currencies.acknowledgements').bind(
      currencies_direct,
      routing_key: 'acknowledgements'
    )

    connection.stop
  end
end
