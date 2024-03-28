module Jobs
  module Folders
    class ResyncDriveFilesCountCache < BaseJob
      def perform
        FolderQuery.pluck("id").ids.each do |folder_id|
          ::Folders::DriveFilesCountCache.new(folder_id).call
        end
      end
    end
  end
end
