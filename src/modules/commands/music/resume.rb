module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:resume, in_voice: true, playing: true) do |event|
      event.voice.continue
      event.send_timed_embed do |e|
        e.description = 'Ok, resumed the video.'
        e.color = 0x7289DA
      end

    end
  end
end
