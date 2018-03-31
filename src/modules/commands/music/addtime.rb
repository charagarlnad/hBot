module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :addtime do |event, time|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.respond 'That is not a number.' if time.is_i? == false
      next if time.is_i? == false
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      event.voice.skip(time.to_i)
      nil
    end
  end
end
