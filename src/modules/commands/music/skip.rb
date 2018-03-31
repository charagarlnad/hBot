module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :skip do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.voice.stop_playing
      event.respond 'Ok, skipping this video.'
      nil
    end
  end
end
