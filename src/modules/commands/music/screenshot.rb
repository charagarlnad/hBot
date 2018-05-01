module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:screenshot, requirements: [:in_voice, :playing], type: :Music, description: 'Send a screenshot of the current video.') do |event|
      `ffmpeg -loglevel panic -y -ss #{event.voice.stream_time.to_i + Bot.masterqueue[event.server.id].first[:skipped_time]} -i #{Bot.masterqueue[event.server.id].first[:location]} -vframes 1 data/musiccache/screenshot.png`
      emb = event.channel.send_file File.new('data/musiccache/screenshot.png')

      sleep(Bot.embedtimeout)
      emb.delete
    end
  end
end
