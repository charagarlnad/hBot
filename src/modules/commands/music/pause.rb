module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:pause, requirements: [:in_voice, :playing]) do |event|
      event.voice.pause
      event.send_timed_embed do |e|
        e.description = 'Ok, paused the video.'
        e.color = 0x7289DA
      end

    end
  end
end
