module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:loop, requirements: [:in_voice, :playing], type: :Music, description: 'Enable/disable looping for the current video.') do |event|
      if $masterqueue[event.server.id].first[:loop]
        $masterqueue[event.server.id].first[:loop] = false
        event.send_timed_embed do |e|
          e.description = 'Ok, disabled looping.'
          e.color = 0x7289DA
        end
      else
        $masterqueue[event.server.id].first[:loop] = true
        event.send_timed_embed do |e|
          e.description = 'Ok, enabled looping.'
          e.color = 0x7289DA
        end
      end

    end
  end
end
