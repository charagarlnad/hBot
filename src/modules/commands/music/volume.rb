module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :volume do |event, vol|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = "I am not in voice."
          e.color = 0x7289DA
        end
      elsif vol.is_i? == false
        emb = event.channel.send_embed do |e|
          e.description = "That is not a number."
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        emb = event.channel.send_embed do |e|
          e.description = "There is nothing playing."
          e.color = 0x7289DA
        end
      else
        event.voice.volume = vol.to_i * 0.01
        emb = event.channel.send_embed do |e|
          e.description = "Ok, set the volume to #{vol.to_i}%"
          e.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete

    end
  end
end
