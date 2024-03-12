module Jobs
  module Discord
    class SendRandomFileMessage < BaseJob
      def perform
        discord_channel_id = data["discord_channel_id"].as_s?
        folder_id = data["folder_id"].as_i?

        return if !(discord_channel_id && folder_id)

        ::Senders::Discord::SendRandomFileMessage
          .new(discord_channel_id: discord_channel_id, folder_id: folder_id)
          .call
      end
    end
  end
end

