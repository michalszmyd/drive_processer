module Jobs
  class DriveFiles
    class FileTextDataResult < BaseJob
      def perform
        drive_file_id = data["extras"].try &.["id"]?.try &.as_i?
        text = data["text"]?.try &.as_s? || ""

        ::DriveFiles::FileTextDataResult.new(id: drive_file_id, text: text).call if drive_file_id
      end
    end
  end
end
