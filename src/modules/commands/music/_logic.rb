module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    $masterqueue = Hash.new { |h, k| h[k] = [] }

    @newemb = lambda do |event, color: $normalcolor, video: $masterqueue[event.server.id].first, queue: false|
      Discordrb::Webhooks::Embed.new title: video[:title],
                                     description: video[:description][0..1023],
                                     fields: [Discordrb::Webhooks::EmbedField.new(name: 'Video info', value: "#{video[:like_count]}#{$like} / #{video[:dislike_count]}#{$dislike}, #{video[:view_count]} Views, Length: #{queue ? "#{seconds_to_str(event.voice.stream_time.to_i)}/" : ''}#{seconds_to_str(video[:length])}#{', Bass Boost enabled' if video[:bassboost]}")],
                                     thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url]),
                                     url: video[:url],
                                     color: color
    end

    @query = lambda do |ytdl, event, bassboost: false, index: nil|
      if index
        sleep(0.1) until ytdl.length >= index + 1
        currvideo = JSON.parse(ytdl[index]).with_indifferent_access
      else
        currvideo = JSON.parse(ytdl).with_indifferent_access
      end
      {}.tap do |video|
        video[:description] = currvideo[:description] || 'N/A'
        video[:title] = currvideo[:fulltitle] || 'N/A'
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

    def self.seconds_to_str(seconds)
      result = Time.at(seconds).utc.strftime('%H:%M:%S')
      until (!result.start_with? '00:') || (result.length == 5)
        result = result.sub('00:', '')
      end
      result
    end

    def self.play_video(event, search, bassboost = false)
      vidsearch = if !event.message.attachments.empty?
                    event.message.attachments.first.url
                  elsif search.length == 1 && search.first.start_with?('http')
                    search.first
                  else
                    "\"ytsearch1:#{search.join(' ')}\""
                  end

      youtubedl = `youtube-dl --restrict-filenames -o "data/musiccache/#{'bassboost-' if bassboost}%(title)s" --dump-json #{vidsearch}`

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
          system("youtube-dl -q --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" #{video[:url]}") unless File.file?(video[:location].sub('/bassboost-', '/'))
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
