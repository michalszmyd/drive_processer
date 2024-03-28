module Jobs
  class BaseJob
    getter data : JSON::Any

    def initialize(payload : String)
      if payload.blank?
        @data = JSON.parse("{}")
      else
        @data = JSON.parse(payload)
      end
    end

    def perform
      raise "Not implemented"
    end
  end
end
