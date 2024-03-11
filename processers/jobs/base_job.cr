module Jobs
  class BaseJob
    getter data : JSON::Any

    def initialize(payload : String)
      Logger.log("Starting #{self.class} with #{payload}")

      if payload.blank?
        @data = JSON.parse("{}")
      else
        @data = JSON.parse(payload)
      end
    end

    def finalize
      Logger.log("Finished #{self.class} with #{data}")
    end

    def perform
      raise "Not implemented"
    end
  end
end
