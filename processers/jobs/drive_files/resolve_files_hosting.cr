module Jobs
  class DriveFiles
    class ResolveFilesHosting < BaseJob
      def perform
        ::DriveFiles::ResolveFilesHosting.new.call
      end
    end
  end
end
