module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    $masterqueue = Hash.new { |h, k| h[k] = [] }
    @embedtimeout = 30

    @newemb = lambda { |event, color, video=$masterqueue[event.server.id].first|
      Discordrb::Webhooks::Embed.new title: video[:title],
      description: video[:description][0..1023],
      fields: [Discordrb::Webhooks::EmbedField.new(name: 'Video info', value: "#{video[:like_count]}<:likes:434777642353295371> / #{video[:dislike_count]}<:dislikes:434777663929057290>, #{video[:view_count]} Views, Length: #{self.seconds_to_str(video[:length])}#{', Bass Boost enabled' if video[:bassboost]}")],
      thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url]),
      url: video[:url],
      color: color
    }
    
    @query = lambda { |ytdl, event, bassboost=false, search=false, index=0|
      if search
        sleep(0.1) until ytdl.length >= index + 1
        currvideo = JSON.parse(ytdl[index]).with_indifferent_access
      else
        currvideo = JSON.parse(ytdl).with_indifferent_access
      end
      video = {}
      video[:description] = currvideo[:description] || 'N/A'
      video[:title] = currvideo[:fulltitle] || 'N/A'
      video[:url] = currvideo[:webpage_url] || 'N/A'
      video[:thumbnail_url] = if currvideo[:thumbnails] then currvideo[:thumbnails].first[:url] else event.bot.profile.avatar_url end
      video[:like_count] = currvideo[:like_count] || 'N/A'
      video[:dislike_count] = currvideo[:dislike_count] || 'N/A'
      video[:view_count] = currvideo[:view_count] || 'N/A'
      video[:length] = currvideo[:duration] || 0
      video[:location] = currvideo[:_filename] + '.mp4'
      video[:loop] = false
      video[:bassboost] = bassboost
      video[:event] = event
      video
    }

    command(:queue, requirements: [:in_voice, :queue_not_empty]) do |event|
      event.send_timed_embed do |embed|
        $masterqueue[event.server.id][0..24].each do |videohash|
          embed.add_field(name: videohash[:title], value: "added by: #{videohash[:event].user.name}, length: #{seconds_to_str(videohash[:length])}#{', bass boost enabled' if videohash[:bassboost]}\n#{videohash[:description]}")
        end
        embed.title = "**hBot Queue** - Video time: #{seconds_to_str(event.voice.stream_time.to_i)}/#{seconds_to_str($masterqueue[event.server.id].first[:length])}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: $masterqueue[event.server.id].length.to_s + ' videos in queue.')
        embed.color = 0x7289DA
      end
    end

    def self.seconds_to_str(seconds)
      result = Time.at(seconds).utc.strftime("%H:%M:%S")
      until (!result.start_with? '00:') || (result.length == 5)
        result = result.sub('00:', '')
      end
      result
    end

    def self.play_video(event, search, bassboost=false)
      begin
        vidsearch = if !event.message.attachments.empty?
          event.message.attachments.first.url
        elsif search.length == 1 && search.first.start_with?('http')
          search.first
        else
          "\"ytsearch1:#{search.join(' ')}\""
        end

        youtubedl = `youtube-dl --restrict-filenames -o "data/musiccache/#{"bassboost-" if bassboost}%(title)s" --dump-json #{vidsearch}`

        add_video(event, @query.call(youtubedl, event, bassboost))

        event.send_timed_embed('Ok, adding to queue:', @newemb.call(event, 0x7289DA))
      rescue => error
        event.send_timed_embed do |embed|
          embed.description = 'Invalid file/search.'
          embed.add_field(name: 'Tell a developer:', value: "#{error.class};\n#{error}", inline: true)
          embed.color = 0xDA7289
        end
      end

    end

    def self.add_video(event, video)      
      unless File.file?(video[:location])
        video[:downloader] = Thread.new do
          system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" #{video[:url]}") unless File.file?(video[:location].sub('/bassboost-', '/'))
          system("ffmpeg -i #{video[:location].gsub('bassboost-', '')} -af bass=g=20:f=200 #{video[:location]}") if video[:location].include? '/bassboost-'
        end
      end

      $masterqueue[event.server.id] << video
      start_player(event) if $masterqueue[event.server.id].length == 1
    end

    def self.start_player(event)
      Thread.new do
        until $masterqueue[event.server.id].empty?

          unless $masterqueue[event.server.id].first[:downloader].nil?
            sleep(0.1) while $masterqueue[event.server.id].first[:downloader].alive?
          end

          emb = event.channel.send_embed('Now playing:', @newemb.call(event, 0x89DA72))
          event.bot.listening = $masterqueue[event.server.id].first[:title]
          event.voice.play_file($masterqueue[event.server.id].first[:location])

          emb.delete

          $masterqueue[event.server.id].shift unless (if $masterqueue[event.server.id].first then $masterqueue[event.server.id].first[:loop] else false end)
        end
      end
      nil
    end

  end
end
