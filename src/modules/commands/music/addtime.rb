module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :addtime do |event, time|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.voice.skip(time.to_i)
    end
  end
end
