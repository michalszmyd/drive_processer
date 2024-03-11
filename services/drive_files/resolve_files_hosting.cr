module DriveFiles
  class ResolveFilesHosting
    def initialize
    end

    def call
      DriveFileQuery
        .new
        .where_not_nil("source_url")
        .where("source_url ILIKE ?", ["%discord%"])
        .where_not({"hosting_source" => DriveFile::FileHosting::Discord.value})
        .results
        .each do |drive_file|
          UpdateQuery
            .new("drive_files", drive_file.id)
            .set("hosting_source", DriveFile::FileHosting::Discord.value)
            .commit

          Logger.log("Updated source for #{drive_file.id}")
        end
    end
  end
end
