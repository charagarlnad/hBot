module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:loop, requirements: [:in_voice, :playing], type: :Music, description: 'Enable/disable looping for the current video.') do |event|
      msg = if $masterqueue[event.server.id].first[:loop]
        $masterqueue[event.server.id].first[:loop] = false
        'Ok, disabled looping.'
      else
        $masterqueue[event.server.id].first[:loop] = true
        'Ok, enabled looping.'
      end
      event.send_timed_embed do |e|
        e.description = msg
        e.color = $normalcolor
      end

    end
  end
end
