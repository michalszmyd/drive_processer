module S3
  module Migrate
    class All
      getter limit : Int32

      def initialize(@limit = 50)
      end

      def call
        query = DriveFileQuery
          .new
          .where({"hosting_source" => ::DriveFile::FileHosting::Discord.value})
          .where_not_nil("source_url")
          .limit(limit)
          .each do |drive_file|
            DriveFile.new(drive_file).call
          end
      end
    end
  end
end
