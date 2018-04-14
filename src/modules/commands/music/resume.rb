module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:resume, requirements: [:in_voice, :playing]) do |event|
      event.voice.continue
      event.send_timed_embed do |e|
        e.description = 'Ok, resumed the video.'
        e.color = 0x7289DA
      end

    end
  end
end
