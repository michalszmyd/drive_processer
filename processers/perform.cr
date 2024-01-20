module Processers
  class Perform
    RESOLVE_CLASSES = {
      "folder" => Jobs::Folders::ExportFolder,
      # "file" => DriveFiles::ZipDriveFileGenerator
    }

    getter payload : String
    getter routing_key : String

    def initialize(@payload, @routing_key)
    end

    def resolve
      resolved_class = RESOLVE_CLASSES[routing_key]

      if resolved_class
        resolved_class
          .new(payload)
          .perform
      end
    end
  end
end
