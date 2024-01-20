module Jobs
  class BaseJob
    getter data : JSON::Any

    def initialize(payload : String)
      @data = JSON.parse(payload)
    end
  end
end
