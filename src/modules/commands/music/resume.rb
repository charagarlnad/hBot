module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :resume do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      event.voice.continue
      event.respond "Ok, resumed the video."
    end
  end
end
