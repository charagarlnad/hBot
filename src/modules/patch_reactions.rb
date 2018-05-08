module Discordrb::API::Channel
  module_function

  @reaction_locks = {}
  def create_reaction(token, channel_id, message_id, emoji)
    @reaction_locks[channel_id] = Mutex.new unless @reaction_locks[channel_id]
    @reaction_locks[channel_id].lock
    emoji = CGI.escape(emoji) unless emoji.ascii_only?
    Discordrb::API.raw_request(
      :put,
      ["#{Discordrb::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/@me",
       nil,
       Authorization: token,
       content_type: :json]
    )
    sleep(0.25)
    @reaction_locks[channel_id].unlock
  end

  def delete_user_reaction(token, channel_id, message_id, emoji, user_id)
    @reaction_locks[channel_id] = Mutex.new unless @reaction_locks[channel_id]
    @reaction_locks[channel_id].lock
    emoji = CGI.escape(emoji) unless emoji.ascii_only?
    Discordrb::API.raw_request(
      :delete,
      ["#{Discordrb::API.api_base}/channels/#{channel_id}/messages/#{message_id}/reactions/#{emoji}/#{user_id}",
       Authorization: token]
    )
    sleep(0.25)
    @reaction_locks[channel_id].unlock
  end
end
# https://github.com/meew0/discordrb/blob/cb074e0f80c078c09ca432893c1601d28bf78adb/lib/discordrb/api/channel.rb#L142
# https://github.com/meew0/discordrb/blob/ef88d4ed27fc2520c1db3fcb21897f60e7d39bc3/lib/discordrb/api.rb#L90
