module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :bplay do |event, *search|
      play_video(event, search, true)
    end
  end
end
