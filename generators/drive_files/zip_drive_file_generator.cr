require "compress/zip"

module DriveFiles
  class ZipDriveFileGenerator
    getter drive_file : DriveFile

    def initialize(@drive_file : DriveFile)
    end

    def to_zip
      File.open("./file.zip", "w") do |file|
        Compress::Zip::Writer.open(file) do |zip|
          zip_to(zip)
        end
      end
    end

    def zip_to(zip : Compress::Zip::Writer)
      folder_name = "drive_file-#{drive_file.id}"

      zip.add_dir(folder_name)

      zip.add("#{folder_name}/#{drive_file.id}.json", drive_file_json)

      fetch_source_file do |filename, io|
        zip.add("#{folder_name}/#{filename}", io) if filename && io
      end
    end

    private def fetch_source_file
      source_url = drive_file.source_url

      return yield nil, nil if source_url.nil?

      uri = URI.parse(source_url)
      filename = uri.path.split('/').last

      HTTP::Client.get(source_url) do |response|
        yield filename, response.body_io
      end
    end

    private def drive_file_json
      {
        id: drive_file.id,
        name: drive_file.name,
        file_name: drive_file.file_name,
        source_url: drive_file.source_url,
        body: drive_file.body,
        external_storage_id: drive_file.external_storage_id,
        deleted_at: drive_file.deleted_at,
        pinned: drive_file.pinned,
        vibrant_color: drive_file.vibrant_color,
        user_id: drive_file.user_id,
        folder_id: drive_file.folder_id
      }.to_json
    end
  end
end
