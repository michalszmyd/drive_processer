module Processers
  class Perform
    RESOLVE_CLASSES = {
      "export_folder"                         => Jobs::Folders::ExportFolder,
      "migrate_folder"                        => Jobs::S3::MigrateFolder,
      "migrate_file"                          => Jobs::S3::MigrateFile,
      "migrate_all"                           => Jobs::S3::Migrate,
      "resolve_files_hosting"                 => Jobs::DriveFiles::ResolveFilesHosting,
      "send_discord_random_file_message"      => Jobs::Discord::SendRandomFileMessage,
      "erase_file"                            => Jobs::DriveFiles::EraseFile,
      "erase_files"                           => Jobs::DriveFiles::EraseFiles,
      "folder_drive_files_count_cache"        => Jobs::Folders::DriveFilesCountCache,
      "resync_folder_drive_files_count_cache" => Jobs::Folders::ResyncDriveFilesCountCache,
      "file_text_data_result"                 => Jobs::DriveFiles::FileTextDataResult,
    }

    getter payload : String
    getter routing_key : String

    def initialize(@payload, @routing_key)
      Logger.log("Performing #{routing_key} with #{payload}")
    end

    def resolve
      resolved_class = RESOLVE_CLASSES[routing_key]?

      if resolved_class
        start = Time.utc
        Logger.log("Start #{routing_key} with #{payload}")
        resolved_class
          .new(payload)
          .perform
        Logger.log("End #{routing_key} with #{payload} - took #{Time.utc - start}")
      else
        Logger.log("Incorrect action: #{@routing_key}")
      end
    rescue e : Azurite::BaseQuery::RecordNotFound | KeyError
      Logger.log("[ERROR]: #{e.inspect}: #{e.message}")
    end
  end
end
