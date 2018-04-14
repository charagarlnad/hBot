module Discordrb::API::Channel
  module_function
  def create_reaction(token, channel_id, message_id, emoji)
    emoji = URI.encode(emoji) unless emoji.ascii_only?
    Discordrb::API.raw_request(
      :put,
      ["#{Discordrb::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/@me",
      nil,
      Authorization: token,
      content_type: :json]
    )
    sleep(0.25)
  end
end
# https://github.com/meew0/discordrb/blob/cb074e0f80c078c09ca432893c1601d28bf78adb/lib/discordrb/api/channel.rb#L142
# https://github.com/meew0/discordrb/blob/ef88d4ed27fc2520c1db3fcb21897f60e7d39bc3/lib/discordrb/api.rb#L90