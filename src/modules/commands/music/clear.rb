module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:clear, requirements: [:in_voice, :playing]) do |event|
      $masterqueue[event.server.id].clear
      event.voice.stop_playing

      event.send_timed_embed do |e|
        e.description = 'Ok, cleared the queue.'
        e.color = 0x7289DA
      end
    end
  end
end
