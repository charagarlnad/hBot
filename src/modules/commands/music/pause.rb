module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:pause, requirements: [:in_voice, :playing], type: :Music, description: 'Pause the currently playing video.') do |event|
      event.voice.pause
      event.send_timed_embed do |e|
        e.description = 'Ok, paused the video.'
        e.color = $normalcolor
      end

    end
  end
end
