module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:pause, in_voice: true, playing: true) do |event|
      event.voice.pause
      event.send_timed_embed do |e|
        e.description = 'Ok, paused the video.'
        e.color = 0x7289DA
      end

    end
  end
end
