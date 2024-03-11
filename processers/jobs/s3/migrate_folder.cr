module Jobs
  module S3
    class MigrateFolder < BaseJob
      def perform
        folder_id = data["id"].as_i?

        return unless folder_id

        folder = FolderQuery.new.find(folder_id)

        ::S3::Migrate::Folder.new(folder).call
      end
    end
  end
end
