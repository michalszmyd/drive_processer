module Processers
  class Perform
    RESOLVE_CLASSES = {
      "export_folder" => Jobs::Folders::ExportFolder,
      "migrate_folder" => Jobs::S3::MigrateFolder,
      "migrate_file" => Jobs::S3::MigrateFile,
      "migrate_all" => Jobs::S3::Migrate,
      "resolve_files_hosting" => Jobs::DriveFiles::ResolveFilesHosting
    }

    getter payload : String
    getter routing_key : String

    def initialize(@payload, @routing_key)
      Logger.log("Received #{routing_key} with #{payload}")
    end

    def resolve
      resolved_class = RESOLVE_CLASSES[routing_key]?

      if resolved_class
        resolved_class
          .new(payload)
          .perform
      else
        Logger.log("Incorrect action: #{@routing_key}")
      end
    end
  end
end
