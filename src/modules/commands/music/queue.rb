module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new { |h, k| h[k] = [] }
    @embedtimeout = 30
    @newemb = lambda { |event, color, video=@masterqueue[event.server.id].first|
      Discordrb::Webhooks::Embed.new title: video[:title],
      description: video[:description][0..1023],
      footer: Discordrb::Webhooks::EmbedFooter.new(text: "#{video[:like_count]} Likes, #{video[:dislike_count]} Dislikes, #{video[:view_count]} Views, #{video[:comment_count]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png'),
      thumbnail: Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url]),
      url: video[:url],
      color: color
    }

    def self.catch_args(event, *args)
      args.each do |arg|
        error = case arg
                when :in_voice then 'I am not in voice.' if event.voice.nil?
                when :playing then 'There is nothing playing.' unless event.voice.playing?
                when :queue_not_empty then 'There is nothing in the queue.' if @masterqueue[event.server.id].empty?
                when :has_arguments_or_attachment then 'A search or attachment is required.' if event.content.split(' ').size == 1 && event.message.attachments.empty?
                when :has_arguments then 'A search is required.' if event.content.split(' ').size == 1 
                else nil
                end
        if error
          emb = event.channel.send_embed do |e|
            e.description = error
            e.color = 0x7289DA
          end
          sleep(@embedtimeout)
          emb.delete
          return false

        end
      end

      true
    end

    command :queue do |event|
      if catch_args(event, :in_voice, :queue_not_empty)
        emb = event.channel.send_embed do |embed|
          @masterqueue[event.server.id][0..24].each do |videohash|
            embed.add_field(name: videohash[:title], value: "added by: #{videohash[:event].user.name}, length: #{videohash[:length]}#{', bass boost enabled' unless videohash[:bassboost].nil?}\n#{videohash[:description]}")
          end
          embed.title = "**hBot Queue** - Video time: #{Time.at(event.voice.stream_time.to_i).utc.strftime('%H:%M:%S')}/#{@masterqueue[event.server.id].first[:length]}"
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: @masterqueue[event.server.id].count.to_s + ' videos in queue.')
          embed.color = 0x7289DA
        end
        sleep(@embedtimeout)
        emb.delete
      end
    end

    def self.play_video(event, search, bassboost=false)
      if catch_args(event, :in_voice, :has_arguments_or_attachment)
        emb = begin
          video = {}
          vidsearch = if !event.message.attachments.empty?
            event.message.attachments.first.url
          elsif search.size == 1 && search.first.start_with?('http')
            search.first
          else
            "\"ytsearch1:#{search.join(' ')}\""
          end

          youtubedl = `youtube-dl --restrict-filenames --get-filename -o "data/musiccache/#{"bassboost-" if bassboost}%(title)s" --dump-json #{vidsearch}`.chomp.split("\n")
          query = JSON.parse(youtubedl[1]).with_indifferent_access
          video[:description] = query[:description] || 'N/A'
          video[:title] = query[:fulltitle] || 'N/A'
          video[:url] = query[:webpage_url] || 'N/A'
          video[:thumbnail_url] = if query[:thumbnails] then query[:thumbnails].first[:url] else event.bot.profile.avatar_url end
          video[:like_count] = query[:like_count] || 'N/A'
          video[:dislike_count] = query[:dislike_count] || 'N/A'
          video[:view_count] = query[:view_count] || 'N/A'
          video[:length] = query[:duration] || 'N/A'
          video[:location] = youtubedl[0] + '.mp4'
          video[:bassboost] = bassboost
          video[:event] = event

          add_video(event, video)

          event.channel.send_embed('Ok, adding to queue:', @newemb.call(event, 0x7289DA))
        rescue => error
          event.channel.send_embed do |e|
            e.description = 'Invalid file/url.'
            e.add_field(name: 'Tell a developer:', value: "#{error.class};\n#{error}", inline: true)
            e.color = 0xDA7289
          end
        end
        sleep(@embedtimeout)
        emb.delete

      end
    end

    def self.add_video(event, video)
      video[:loop] = false
      
      unless File.file?(video[:location])
        video[:downloader] = Thread.new do
          system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" #{video[:url]}") unless File.file?(video[:location].gsub('bassboost-', ''))
          system("ffmpeg -i #{video[:location].gsub('bassboost-', '')} -af bass=g=20:f=200 #{video[:location]}") if video[:location].include? '/bassboost-'
        end
      end

      @masterqueue[event.server.id] << video
      start_player(event) if @masterqueue[event.server.id].size == 1
    end

    def self.start_player(event)
      Thread.new do
        until @masterqueue[event.server.id].empty?

          unless @masterqueue[event.server.id].first[:downloader].nil?
            until @masterqueue[event.server.id].first[:downloader].alive? == false
              sleep(0.1)
            end
          end

          emb = event.channel.send_embed('Now playing:', @newemb.call(event, 0x89DA72))
          event.bot.listening = @masterqueue[event.server.id].first[:title]
          event.voice.play_file(@masterqueue[event.server.id].first[:location])

          emb.delete

          break if @masterqueue[event.server.id].empty?
          @masterqueue[event.server.id].shift unless @masterqueue[event.server.id].first[:loop]
        end
      end
      nil
    end

  end
end
