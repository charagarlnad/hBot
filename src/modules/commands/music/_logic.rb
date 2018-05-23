module Bot::DiscordCommands
  module Music
    @newemb = lambda do |event, color: Bot.normalcolor, video: Bot.masterqueue[event.server.id].first, queue: false|
      Discordrb::Webhooks::Embed.new.tap do |embed|
        embed.title = video.title
        embed.description = video.description[0..1023]
        embed.add_field(name: 'Video info', value: "#{video.like_count}#{Bot.like} / #{video.dislike_count}#{Bot.dislike}, #{video.view_count} Views, Length: #{queue ? "#{seconds_to_str(event.voice.stream_time.to_i + video.skipped_time)}/" : ''}#{seconds_to_str(video.length)}")
        embed.add_field(name: 'Video filters', value: video.filters.join(' ')) if video.filters.any?
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video.thumbnail_url)
        embed.url = video.url
        embed.color = color
      end
    end

    Process.spawn('python3 ytdl_host.py')
    sleep(0.5)
    @socket = UNIXSocket.new('test.s')
    @request_lock = Mutex.new

    def self.request_vid(type, args)
      @request_lock.lock
      @socket.puts("#{type}|#{args}")
      response = ''
      response << @socket.recv(8192).chomp until response.end_with?('|||END|||')
      response.delete_suffix!('|||END|||')
      video = JSON.parse(response)
      if video.is_a?(Hash)
        video.symbolize_keys
      elsif video.is_a?(Array)
        video.map(&:symbolize_keys)
      elsif video == 'error'
        raise 'A error occured, was the URL/search incorrect?'
      else
        true
      end
    ensure
      @request_lock.unlock
    end

    def self.seconds_to_str(seconds)
      result = Time.at(seconds).utc.strftime('%H:%M:%S')
      until (!result.start_with? '00:') || (result.length == 5)
        result.sub!('00:', '')
      end
      result
    end

    def self.add_video(video)
      unless File.file?(video.location)
        video.downloader = Thread.new do
          request_vid(:download, video.url) unless File.file?(video.base_location)
          system("ffmpeg -loglevel panic -y -i #{video.base_location} -af \"#{video.ffmpeg_arguments}\" #{video.location}") unless File.file?(video.location)
        end
      end

      Bot.masterqueue[video.event.server.id] << video
      start_player(video.event) if Bot.masterqueue[video.event.server.id].length == 1
    end

    def self.start_player(event)
      Thread.new do
        until Bot.masterqueue[event.server.id].empty?

          unless Bot.masterqueue[event.server.id].first.downloader.nil?
            sleep(0.1) while Bot.masterqueue[event.server.id].first.downloader.alive?
          end

          emb = event.channel.send_embed(Bot.masterqueue[event.server.id].first.loop ? 'Now looping:' : 'Now playing:', @newemb.call(event, color: Bot.othercolor))
          event.voice.play_file(Bot.masterqueue[event.server.id].first.location)

          emb.delete

          Bot.masterqueue[event.server.id].shift unless Bot.masterqueue[event.server.id].first&.loop
        end
      end
      nil
    end
  end
end
