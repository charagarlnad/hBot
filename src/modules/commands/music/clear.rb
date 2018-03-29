module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :clear do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.voice.stop_playing
      @masterqueue[event.server.id].clear
      nil
    end
  end
end
