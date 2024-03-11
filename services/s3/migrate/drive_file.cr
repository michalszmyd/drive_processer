module S3
  module Migrate
    class DriveFile
      getter drive_file : ::DriveFile

      def initialize(@drive_file)
      end

      def call
        return if drive_file.hosting_source == ::DriveFile::FileHosting::AmazonS3.value

        storage_id = drive_file.external_storage_id
        source_url = drive_file.source_url

        if storage_id && source_url
          origin_path = URI.parse(source_url).path.split('/')
          origin_filename = origin_path[-1]
          origin_file_id = origin_path[-2]
          origin_channel_id = origin_path[-3]

          Discord::API::Messages.get(channel_id: origin_channel_id, id: storage_id) do |message|
            HTTP::Client.get(message.attachments[0].url) do |response|
              tempfile = ::File.tempfile(origin_filename)

              ::File.write(tempfile.path, response.body_io)
              uploaded_file = S3::UploadFile.new(name: origin_filename, attachment: tempfile).upload_file do |uploaded_file|
                source = uploaded_file.presigned_source

                UpdateQuery
                  .new("drive_files", drive_file.id)
                  .set("legacy_external_storage_id", storage_id)
                  .set("legacy_source_url", source_url)
                  .set("file_name", origin_filename)
                  .set("name", drive_file.name)
                  .set("external_storage_id", uploaded_file.id)
                  .set("hosting_source", ::DriveFile::FileHosting::AmazonS3.value)
                  .set("source_url", source.url)
                  .set("source_signature_duration", source.expires)
                  .set("source_signature_created_at", source.created_at)
                  .commit

                Logger.log("Migrated: #{drive_file.id}")
              end

              tempfile.close
            end
          end
        end
      end
    end
  end
end
