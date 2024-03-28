module Folders
  class DriveFilesCountCache
    getter folder_id : Int32 | Int64

    def initialize(@folder_id)
    end

    def call
      UpdateQuery
        .new(record_id: folder.id, table_name: "folders")
        .set("drive_files_count", drive_files_count)
        .commit
    end

    private def folder
      FolderQuery.new.find(folder_id)
    end

    private def drive_files_count
      DriveFileQuery
        .new
        .where({"folder_id" => folder_id})
        .where_nil("deleted_at")
        .select_count
    end
  end
end
