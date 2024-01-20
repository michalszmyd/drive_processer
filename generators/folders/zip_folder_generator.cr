require "compress/zip"

module Folders
  class ZipFolderGenerator
    EXPORT_PATH = ENV["UPLOAD_FILES_DIR"]

    getter folder : Folder
    getter filename : String
    getter filepath : String

    def initialize(@folder : Folder)
      @filename = "#{folder.name.underscore.gsub(' ', '_')}-#{folder.id}.zip"
      @filepath = "#{EXPORT_PATH}/#{filename}"
    end

    def to_zip
      File.open(filepath, "w") do |file|
        Compress::Zip::Writer.open(file) do |zip|
          zip.add("folder.json", folder_json)

          drive_files.each do |drive_file|
            generator = ::DriveFiles::ZipDriveFileGenerator.new(drive_file)

            generator.zip_to(zip)
          end
        end
      end

      yield filename, filepath
    end

    private def drive_files
      DriveFileQuery.new.where({"folder_id" => folder.id})
    end

    private def folder_json
      {
        id: folder.id,
        name: folder.name,
        folder_private: folder.folder_private,
        parent_folder_id: folder.parent_folder_id,
        created_at: folder.created_at,
        updated_at: folder.updated_at
      }.to_json
    end
  end
end
