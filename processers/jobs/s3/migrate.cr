module Jobs
  module S3
    class Migrate < BaseJob
      def perform
        limit_value = data["limit"].as_i?

        if limit_value
          ::S3::Migrate::All.new(limit_value).call
        else
          ::S3::Migrate::All.new.call
        end
      end
    end
  end
end
