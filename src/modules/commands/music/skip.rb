module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :skip do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.voice.stop_playing
    end
  end
end
