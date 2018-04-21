module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    $masterqueue = Hash.new { |h, k| h[k] = [] }

    @newemb = lambda do |event, color: $normalcolor, video: $masterqueue[event.server.id].first, queue: false|
      Discordrb::Webhooks::Embed.new.tap do |embed|
        embed.title = video[:title]
        embed.description = video[:description][0..1023]
        embed.add_field(name: 'Video info', value: "#{video[:like_count]}#{$like} / #{video[:dislike_count]}#{$dislike}, #{video[:view_count]} Views, Length: #{queue ? "#{seconds_to_str(event.voice.stream_time.to_i)}/" : ''}#{seconds_to_str(video[:length])}#{', Bass Boost enabled' if video[:bassboost]}")
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url])
        embed.url = video[:url]
        embed.color = color
      end
    end

    @query = lambda do |ytdl, event, bassboost: false, index: nil|
      if index
        sleep(0.1) until ytdl.length >= index + 1
        currvideo = ytdl[index]
      else
        currvideo = ytdl
      end
      {}.tap do |video|
        video[:description] = currvideo[:description] || 'N/A'
        video[:title] = currvideo[:title] || 'N/A'
        video[:url] = currvideo[:webpage_url] || 'N/A'
        video[:thumbnail_url] = currvideo[:thumbnails] ? currvideo[:thumbnails].first[:url] : event.bot.profile.avatar_url
        video[:like_count] = currvideo[:like_count] || 'N/A'
        video[:dislike_count] = currvideo[:dislike_count] || 'N/A'
        video[:view_count] = currvideo[:view_count] || 'N/A'
        video[:length] = currvideo[:duration] || 0
        video[:location] = currvideo[:_filename] + '.mp4'
        video[:loop] = false
        video[:bassboost] = bassboost
        video[:event] = event
      end
    end

    # About a 1 to 1.5 second improvement over calling youtube-dl as a program every time.
    Process.spawn('python3 ytdl_host.py')
    sleep(0.5)
    @socket = UNIXSocket.new('test.s')
    @request_lock = Mutex.new
    def self.request_vid(request, args)
      @request_lock.lock
      value =
        if request == :play
          @socket.puts('play ' + args)
          response = @socket.recv(16777216).chomp
          JSON.parse(response).with_indifferent_access
        elsif request == :search
          @socket.puts('search ' + args)
          videos = []
          8.times do
            response = @socket.recv(16777216).chomp
            videos << JSON.parse(response).with_indifferent_access
          end
          videos
        elsif request == :download
          @socket.puts('download ' + args)
          response = @socket.recv(16777216).chomp
          true
        elsif request == :kill
          @socket.puts('kill')
          true
        end
      @request_lock.unlock
      value
    end

    def self.seconds_to_str(seconds)
      result = Time.at(seconds).utc.strftime('%H:%M:%S')
      until (!result.start_with? '00:') || (result.length == 5)
        result = result.sub('00:', '')
      end
      result
    end

    def self.play_video(event, search, bassboost = false)
      vidsearch =
        if !event.message.attachments.empty?
          event.message.attachments.first.url
        elsif search.length == 1 && search.first.start_with?('http')
          search.first
        else
          search.join(' ')
        end

      youtubedl = request_vid(:play, vidsearch)

      add_video(@query.call(youtubedl, event, bassboost: bassboost))

      event.send_timed_embed('Ok, adding to queue:', @newemb.call(event, video: $masterqueue[event.server.id].last))
    rescue => error
      event.send_timed_embed do |embed|
        embed.description = 'Invalid file/search.'
        embed.add_field(name: 'Tell a developer:', value: "#{error.class};\n#{error}", inline: true)
        embed.color = $errorcolor
      end
    end

    def self.add_video(video)
      unless File.file?(video[:location])
        video[:downloader] = Thread.new do
          request_vid(:download, video[:url])
          system("ffmpeg -loglevel panic -i #{video[:location].sub('/bassboost-', '/')} -af bass=g=20:f=200 #{video[:location]}") if video[:location].include? '/bassboost-'
        end
      end

      $masterqueue[video[:event].server.id] << video
      start_player(video[:event]) if $masterqueue[video[:event].server.id].length == 1
    end

    def self.start_player(event)
      Thread.new do
        until $masterqueue[event.server.id].empty?

          unless $masterqueue[event.server.id].first[:downloader].nil?
            sleep(0.1) while $masterqueue[event.server.id].first[:downloader].alive?
          end

          emb = event.channel.send_embed('Now playing:', @newemb.call(event, color: $othercolor))
          event.bot.listening = $masterqueue[event.server.id].first[:title]
          event.voice.play_file($masterqueue[event.server.id].first[:location])

          emb.delete

          $masterqueue[event.server.id].shift unless $masterqueue[event.server.id].first&.[](:loop)
        end
      end
      nil
    end
  end
end
