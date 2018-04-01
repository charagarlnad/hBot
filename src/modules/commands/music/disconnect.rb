module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :disconnect do |event|
      event.respond 'I am not in voice.' if event.voice.nil?
      next if event.voice.nil?

      @masterqueue[event.server.id].clear
      event.voice.stop_playing
      event.voice.destroy

      emb = event.channel.send_embed do |e|
        e.description = 'Disconnected.'
        e.color = 0x7289DA
      end

      sleep(8)
      emb.delete

    end
  end
end
