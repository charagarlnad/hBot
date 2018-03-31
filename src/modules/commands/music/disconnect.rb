module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :disconnect do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil

      @masterqueue[event.server.id].clear
      event.voice.stop_playing
      event.voice.destroy
      event.respond 'Disconnected.'
      nil
    end
  end
end
