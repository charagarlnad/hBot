module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:play, requirements: [:in_voice, :has_arguments_or_attachment], type: :Music, description: 'Add a [**Video/Search**] to the music queue.') do |event, *search|
      play_video(event, search)
    end
  end
end
