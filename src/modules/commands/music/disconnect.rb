module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :disconnect do |event|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      else
        @masterqueue[event.server.id].clear unless @masterqueue[event.server.id].nil?
        event.voice.stop_playing
        event.voice.destroy

        emb = event.channel.send_embed do |e|
          e.description = 'Disconnected.'
          e.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
