module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:skip, requirements: [:in_voice, :playing], type: :Music, description: 'Skip the currently playing video.') do |event|
      event.voice.stop_playing
      event.send_timed_embed do |e|
        e.description = 'Ok, skipping video.'
        e.color = $normalcolor
      end
    end
  end
end
