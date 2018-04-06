module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :addtime do |event, time|
      emb = if event.voice.nil?
        event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif time.nil?
        event.channel.send_embed do |e|
          e.description = 'A number is required.'
          e.color = 0x7289DA
        end
      elsif time.is_i? == false
        event.channel.send_embed do |e|
          e.description = 'That is not a number.'
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        event.channel.send_embed do |e|
          e.description = 'There is nothing playing.'
          e.color = 0x7289DA
        end
      else
        event.voice.skip(time.to_i)
        event.channel.send_embed do |e|
          e.description = "Ok, skipped #{time} seconds ahead."
          e.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
