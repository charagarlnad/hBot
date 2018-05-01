module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:loop, requirements: [:in_voice, :playing], type: :Music, description: 'Enable/disable looping for the current video.') do |event|
      msg =
        if Bot.masterqueue[event.server.id].first[:loop]
          Bot.masterqueue[event.server.id].first[:loop] = false
          'Ok, disabled looping.'
        else
          Bot.masterqueue[event.server.id].first[:loop] = true
          'Ok, enabled looping.'
        end
      event.send_timed_embed do |e|
        e.description = msg
      end
    end
  end
end
