module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:skip, in_voice: true, playing: true) do |event|
      event.voice.stop_playing
      event.send_timed_embed do |e|
        e.description = 'Ok, skipping video.'
        e.color = 0x7289DA
      end

    end
  end
end
