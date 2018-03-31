module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :volume do |event, vol|
      event.respond 'I am not in voice.' if event.voice == nil
      next if event.voice == nil
      event.respond 'That is not a number.' if vol.is_i? == false
      next if vol.is_i? == false

      event.voice.volume = vol.to_i * 0.01
      
      emb = event.channel.send_embed() do |e|
        e.description = "Ok, set the volume to #{vol.to_i}%"
        e.color = 0x7289DA
      end

      Thread.new do
        sleep(8) 
        emb.delete
      end

      nil
    end
  end
end
