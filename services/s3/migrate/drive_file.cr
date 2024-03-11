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

                AppDatabase.exec("
                  UPDATE drive_files
                    SET
                      legacy_external_storage_id = $2,
                      legacy_source_url = $3,
                      file_name = $4,
                      name = $5,
                      external_storage_id = $6,
                      hosting_source = $7,
                      source_url = $8,
                      source_signature_duration = $9,
                      source_signature_created_at = $10
                    WHERE id = $1
                ",
                  drive_file.id,
                  storage_id,
                  source_url,
                  origin_filename,
                  drive_file.name,
                  uploaded_file.id,
                  ::DriveFile::FileHosting::AmazonS3.value,
                  source.url,
                  source.expires,
                  source.created_at
                )

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
