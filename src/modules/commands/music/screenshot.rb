module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :screenshot do |event|
      if event.voice.nil?
        emb = event.channel.send_embed do |e|
          e.description = "I am not in voice."
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        emb = event.channel.send_embed do |e|
          e.description = "There is nothing playing."
          e.color = 0x7289DA
        end
      else
        video = FFMPEG::Movie.new(@masterqueue[event.server.id].first[:location])
        video.screenshot('data/musiccache/screenshot.png', seek_time: event.voice.stream_time.to_i)
        emb =event.channel.send_file File.new('data/musiccache/screenshot.png')
      end

      sleep(@embedtimeout)
      emb.delete
      
    end
  end
end
