module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    command(:screenshot, requirements: [:in_voice, :playing], type: :Music, description: 'Send a screenshot of the current video.') do |event|
      file = IO.popen(['ffmpeg', '-loglevel', 'panic', '-ss', (event.voice.stream_time.to_i + Bot.masterqueue[event.server.id].first[:skipped_time]).to_s, '-i', Bot.masterqueue[event.server.id].first[:location], '-f', 'image2', 'pipe:']).read
      emb = event.channel.send_file BinaryImage.new(file, "#{event.message.id}.png")

      sleep(Bot.embedtimeout)
      emb.delete
    end
  end
end
