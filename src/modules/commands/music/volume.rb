module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:volume, in_voice: true, playing: true, arguments_is_int: true) do |event, vol|
        event.voice.volume = vol.to_i * 0.01
        event.send_timed_embed do |e|
          e.description = "Ok, set the volume to #{vol.to_i}%"
          e.color = 0x7289DA
        end

    end
  end
end
