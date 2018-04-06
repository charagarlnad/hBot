module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :play do |event, *search|
      play_video(event, search)
    end
  end
end
