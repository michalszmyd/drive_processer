module Jobs
  class DriveFiles
    class EraseFiles < BaseJob
      def perform
        older_than_in_days = data["older_than_in_days"]?.try &.as_i?

        ::DriveFiles::EraseFiles.new(older_than_in_days).call
      end
    end
  end
end
