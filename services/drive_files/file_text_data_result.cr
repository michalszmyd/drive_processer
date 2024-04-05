module DriveFiles
  class FileTextDataResult
    getter id : Int32
    getter text : String

    def initialize(@id, @text)
    end

    def call
      UpdateQuery
        .new("drive_files", id)
        .set_json_b("metadata", {key: "text", value: text})
        .commit
    end
  end
end
