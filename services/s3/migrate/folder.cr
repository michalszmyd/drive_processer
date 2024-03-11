module S3
  module Migrate
    class Folder
      getter folder : ::Folder

      def initialize(@folder)
      end

      def call
        DriveFileQuery.new.where({"folder_id" => folder.id}).each do |drive_file|
          DriveFile.new(drive_file).call
        end
      end
    end
  end
end
