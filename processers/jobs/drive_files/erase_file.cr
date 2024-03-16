module Jobs
  class DriveFiles
    class EraseFile < BaseJob
      def perform
        id = data["id"].as_i?

        if id
          drive_file = DriveFileQuery.new.deletable.find(id)

          ::DriveFiles::EraseFile.new(drive_file).call
        end
      end
    end
  end
end
