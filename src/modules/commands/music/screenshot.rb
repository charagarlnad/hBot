module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :screenshot do |event|
      video = FFMPEG::Movie.new(@masterqueue[event.server.id].first[:location])
      video.screenshot('data/musiccache/screenshot.png', seek_time: event.voice.stream_time.to_i)
      event.channel.send_file File.new('data/musiccache/screenshot.png')
    end
  end
end
