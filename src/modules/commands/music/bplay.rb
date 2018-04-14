module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:bplay, in_voice: true, has_arguments_or_attachment: true) do |event, *search|
      play_video(event, search, true)
    end
  end
end
