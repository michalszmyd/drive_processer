module DriveFiles
  class EraseFile
    getter drive_file : DriveFile

    def initialize(@drive_file)
    end

    def call
      external_storage_id = drive_file.external_storage_id

      if drive_file.hosting_source == DriveFile::FileHosting::AmazonS3.value && external_storage_id
        Logger.log("Removing AWS: #{external_storage_id}")
        aws_deleted = S3::File.new(external_storage_id).delete

        return false unless aws_deleted
      end

      DeleteQuery.new("drive_files", drive_file.id).commit

      Logger.log("Removing: #{drive_file.id.inspect}")
    end
  end
end
