module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :addtime do |event, time|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = "I am not in voice."
          e.color = 0x7289DA
        end
      elsif time == nil
        emb = event.channel.send_embed do |e|
          e.description = "A number is required."
          e.color = 0x7289DA
        end
      elsif time.is_i? == false
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
        event.voice.skip(time.to_i)
        emb = event.channel.send_embed do |e|
          e.description = "Ok, skipped #{time} seconds ahead."
          e.color = 0x7289DA
        end
      end

      sleep(8)
      emb.delete

    end
  end
end
