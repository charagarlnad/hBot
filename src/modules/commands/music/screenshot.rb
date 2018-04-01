module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command :screenshot do |event|
      event.respond 'I am not in voice.' if event.voice.nil?
      next if event.voice.nil?
      event.respond 'There is nothing playing.' if event.voice.playing? == false
      next if event.voice.playing? == false

      video = FFMPEG::Movie.new(@masterqueue[event.server.id].first[:location])
      video.screenshot('data/musiccache/screenshot.png', seek_time: event.voice.stream_time.to_i)
      event.channel.send_file File.new('data/musiccache/screenshot.png')
    end
  end
end
