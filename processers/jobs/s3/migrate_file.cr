module Jobs
  module S3
    class MigrateFile < BaseJob
      def perform
        file_id = data["id"].as_i?

        return unless file_id

        file = DriveFileQuery.new.find(file_id)

        ::S3::Migrate::DriveFile.new(file).call
      end
    end
  end
end
