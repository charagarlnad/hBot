module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :loop do |event|
      emb = if event.voice.nil?
        event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        event.channel.send_embed do |e|
          e.description = 'There is nothing playing.'
          e.color = 0x7289DA
        end
      elsif @masterqueue[event.server.id].first[:loop]
        @masterqueue[event.server.id].first[:loop] = false
        event.channel.send_embed do |e|
          e.description = 'Ok, disabled looping.'
          e.color = 0x7289DA
        end
      else
        @masterqueue[event.server.id].first[:loop] = true
        event.channel.send_embed do |e|
          e.description = 'Ok, enabled looping.'
          e.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
