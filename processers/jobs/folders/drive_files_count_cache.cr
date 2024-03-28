module Jobs
  module Folders
    class DriveFilesCountCache < BaseJob
      def perform
        folder_id = data["id"].as_i?

        ::Folders::DriveFilesCountCache.new(folder_id).call if folder_id
      end
    end
  end
end
