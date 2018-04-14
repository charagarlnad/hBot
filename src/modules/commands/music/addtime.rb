module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:addtime, in_voice: true, playing: true, arguments_is_int: true) do |event, time|
      event.voice.skip(time.to_i)
      event.send_timed_embed do |e|
        e.description = "Ok, skipped #{time} seconds ahead."
        e.color = 0x7289DA
      end
    end
  end
end
