module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:disconnect, requirements: [:in_voice], type: :Music, description: 'Disconnect and clear the music queue.') do |event|
      Bot.masterqueue[event.server.id]&.clear
      event.voice.stop_playing
      event.voice.destroy

      event.send_timed_embed do |e|
        e.description = 'Disconnected.'
      end
    end
  end
end
