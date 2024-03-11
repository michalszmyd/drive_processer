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
          AppDatabase.exec("
            UPDATE drive_files
              SET
                hosting_source = $2
              WHERE id = $1
          ",
            drive_file.id,
            DriveFile::FileHosting::Discord.value
          )

          Logger.log("Updated source for #{drive_file.id}")
        end
    end
  end
end
