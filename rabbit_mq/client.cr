require "amqp-client"

RABBIT_MQ_URL = ENV["RABBIT_MQ_CONNECT_URL"]
QUEUE_NAME = ENV["RABBIT_MQ_QUEUE_NAME"]
QUEUE_TYPE = "classic"

module RabbitMQ
  class Listener
    def subscribe(&block : AMQP::Client::DeliverMessage -> _)
      subscribe_queue do |queue|
        queue.subscribe(block: true, no_ack: false, args: AMQP::Client::Arguments.new({"x-stream-offset": "first"})) do |msg|
          puts "Received: #{msg.routing_key} - #{msg.body_io} #{msg.body_io.class}"

          block.call(msg)

          msg.ack
        end
      end
    end

    private def subscribe_queue
      AMQP::Client.start(RABBIT_MQ_URL) do |client|
        client.channel do |channel|
          channel.prefetch(10)
          queue = channel.queue(QUEUE_NAME, args: AMQP::Client::Arguments.new({"x-queue-type": QUEUE_TYPE}))

          puts "Waiting for messages. To exit press CTRL+C"

          yield queue
        end
      end
    end
  end
end


