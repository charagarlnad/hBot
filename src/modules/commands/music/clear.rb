module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:clear, requirements: [:in_voice, :playing], type: :Music, description: 'Clear the music queue.') do |event|
      $masterqueue[event.server.id].clear
      event.voice.stop_playing

      event.send_timed_embed do |e|
        e.description = 'Ok, cleared the queue.'
        e.color = $normalcolor
      end
    end
  end
end
