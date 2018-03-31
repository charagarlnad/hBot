module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :clear do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil

      @masterqueue[event.server.id].clear
      event.voice.stop_playing
      event.respond 'Cleared the queue.'
      nil
    end
  end
end
