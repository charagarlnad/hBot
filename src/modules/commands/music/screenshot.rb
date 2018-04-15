module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:screenshot, requirements: [:in_voice, :playing], type: :Music, description: 'Send a screenshot of the current video.') do |event|
      video = FFMPEG::Movie.new($masterqueue[event.server.id].first[:location])
      video.screenshot('data/musiccache/screenshot.png', seek_time: event.voice.stream_time.to_i)
      emb = event.channel.send_file File.new('data/musiccache/screenshot.png')

      sleep(@embedtimeout)
      emb.delete
    end
  end
end
