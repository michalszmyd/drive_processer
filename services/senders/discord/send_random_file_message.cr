module Senders
  module Discord
    class SendRandomFileMessage
      getter discord_channel_id : String
      getter folder_id : Int32

      def initialize(@discord_channel_id, @folder_id)
      end

      def call
        drive_files = DriveFileQuery.new.where({"folder_id" => folder_id}).where_not_nil("source_url").results
        drive_file = drive_files.sample
        external_storage_id = drive_file.external_storage_id

        source_url = external_storage_id ? S3::File.new(external_storage_id).presigned_source.url : ""

        ::Discord::API::Messages.create(
          content: source_url,
          channel_id: discord_channel_id
        ) do |message|
          Logger.log("Pushed to discord #{discord_channel_id}: #{message.inspect}")
        end
      end
    end
  end
end
