module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:bplay, requirements: [:in_voice, :has_arguments_or_attachment], type: :Music, description: 'Add a [**Video/Search**] to the music queue with bass boost.') do |event, *search|
      play_video(event, search, true)
    end
  end
end
