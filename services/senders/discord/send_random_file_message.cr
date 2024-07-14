module Senders
  module Discord
    class SendRandomFileMessage
      getter discord_channel_id : String
      getter folder_id : Int32

      HOST_APP_URL = ENV["HOST_APP_URL"]

      def initialize(@discord_channel_id, @folder_id)
      end

      def call
        drive_files = DriveFileQuery.new.where({"folder_id" => folder_id}).where_not_nil("source_url").results
        drive_file = drive_files.sample
        external_storage_id = drive_file.external_storage_id

        DriveFiles::Share::Write.new(drive_file).call do |payload|
          url = "#{HOST_APP_URL}/files/embed?#{payload.to_url_params}"

          Logger.log(url.inspect)

          ::Discord::API::Messages.create(
            content: url,
            channel_id: discord_channel_id
          ) do |message|
            Logger.log("Pushed to discord #{discord_channel_id}: #{message.inspect}")
          end
        end
      end
    end
  end
end
