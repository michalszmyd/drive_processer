module Jobs
  module Activities
    class CreateActivity < BaseJob
      def perform
        resource = data["resource"].as_i?
        resource_id = data["resource_id"].as_i?
        user_id = data["user_id"].as_i64?
        application_id = data["application_id"].as_i64?

        action = data["action"].as_i?
        metadata = data["metadata"].to_json
        request_info = data["request_info"].to_json

        return unless resource

        InsertQuery
          .new("activities")
          .set("resource", resource)
          .set("resource_id", resource_id)
          .set("user_id", user_id)
          .set("application_id", application_id)
          .set("action", action)
          .set("request_info", request_info)
          .set("metadata", metadata)
          .commit
      end
    end
  end
end
