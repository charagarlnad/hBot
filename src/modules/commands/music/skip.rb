module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :skip do |event|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        emb = event.channel.send_embed do |e|
          e.description = 'There is nothing playing.'
          e.color = 0x7289DA
        end
      else
        event.voice.stop_playing
        emb = event.channel.send_embed do |e|
          e.description = 'Ok, skipping video.'
          e.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
