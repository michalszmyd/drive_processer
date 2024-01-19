require "./config"

RabbitMQ::Listener.new.subscribe do |message|
  Processers::Perform.new(
    payload: message.body_io.to_s,
    routing_key: message.routing_key
  ).resolve
end
