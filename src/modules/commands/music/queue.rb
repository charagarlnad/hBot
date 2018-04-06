module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new { |h, k| h[k] = [] }
    @embedtimeout = 30
    command :queue do |event|
      emb = if event.voice.nil?
        event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif event.voice.playing? == false
        event.channel.send_embed do |e|
          e.description = 'There is nothing playing.'
          e.color = 0x7289DA
        end
      elsif @masterqueue[event.server.id].empty?
        event.channel.send_embed do |e|
          e.description = 'There is nothing in the queue.'
          e.color = 0x7289DA
        end
      else
        event.channel.send_embed do |embed|
          @masterqueue[event.server.id][0..24].each do |videohash|
            embed.add_field(name: videohash[:title], value: "added by: #{videohash[:event].user.name}, length: #{videohash[:length]}#{', bass boost enabled' unless videohash[:bassboost].nil?}\n#{videohash[:description]}")
          end
          embed.title = "**hBot Queue** - Video time: #{Time.at(event.voice.stream_time.to_i).utc.strftime('%H:%M:%S')}/#{@masterqueue[event.server.id].first[:length]}"
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: @masterqueue[event.server.id].count.to_s + ' videos in queue.')
          embed.color = 0x7289DA
        end
      end

      sleep(@embedtimeout)
      emb.delete
    end

    def self.play_video(event, search, bassboost=false)
      emb = if event.voice.nil?
        event.channel.send_embed do |e|
          e.description = 'I am not in voice.'
          e.color = 0x7289DA
        end
      elsif search.empty?
        event.channel.send_embed do |e|
          e.description = 'A search is required.'
          e.color = 0x7289DA
        end
      else
        video = {}
        if search.size == 1 && search.first.include?('http') && !search.first.include?('youtube.com')
          if `youtube-dl -j #{search.first}`.chomp == ''
            emb = event.channel.send_embed do |e|
              e.description = 'Invalid url.'
              e.color = 0x7289DA
            end

            sleep(@embedtimeout)
            emb.delete
            return nil
          end
          video[:description] = 'N/A'
          video[:title] = `youtube-dl --get-filename -o "%(title)s" #{search.first}`
          video[:url] = search.first
          video[:thumbnail_url] = event.bot.profile.avatar_url
          video[:like_count] = 'N/A'
          video[:dislike_count] = 'N/A'
          video[:comment_count] = 'N/A'
          video[:view_count] = 'N/A'
          video[:length] = `youtube-dl -j #{search.first} | jq .duration`
        else
          query = Yt::Collections::Videos.new.where(q: search.join(' '), safe_search: 'none', order: 'relevance').first

          sleep(0.05) while query.title.nil?

          video[:description] = query.description
          video[:title] = query.title
          video[:url] = 'https://www.youtube.com/watch?v=' + query.id
          video[:thumbnail_url] = query.thumbnail_url
          video[:like_count] = query.like_count
          video[:dislike_count] = query.dislike_count
          video[:comment_count] = query.comment_count
          video[:view_count] = query.view_count
          video[:length] = query.length
        end
        video[:bassboost] = true if bassboost

        event.channel.send_embed('Ok, adding to queue:') do |e|
          e.add_field(name: 'Added by:', value: video[:event].user.name, inline: true)
          e.add_field(name: 'Bass Boost:', value: 'Enabled', inline: true) unless video[:bassboost].nil?
          e.title = video[:title]
          e.description = video[:description]
          e.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{video[:like_count]} Likes, #{video[:dislike_count]} Dislikes, #{video[:view_count]} Views, #{video[:comment_count]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
          e.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: video[:thumbnail_url])
          e.url = video[:url]
          e.color = 0x7289DA
        end

        add_video(event, video)
      end

      sleep(@embedtimeout)
      emb.delete
    end

    def self.add_video(event, video, bassboost=false)
      video[:location] = "data/musiccache/#{"bassboost-" if bassboost}#{`youtube-dl --restrict-filenames --get-filename -o "%(title)s" #{video[:url]}`.chomp}.mp4"
      video[:event] = event
      video[:loop] = false
      
      unless File.file?(video[:location])
        video[:downloader] = Thread.new do
          system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" #{video[:url]}") unless File.file?(video[:location].gsub('bassboost-', ''))
          system("ffmpeg -i #{video[:location].gsub('bassboost-', '')} -af bass=g=20:f=200 #{video[:location]}") if video.location.include? '/bassboost'
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

          emb = event.channel.send_embed('Now playing:') do |embed|
            embed.add_field(name: 'Added by:', value: @masterqueue[event.server.id].first[:event].user.name, inline: true)
            embed.add_field(name: 'Bass Boost:', value: 'Enabled', inline: true) unless @masterqueue[event.server.id].first[:bassboost].nil?
            embed.description = @masterqueue[event.server.id].first[:description]
            embed.title = @masterqueue[event.server.id].first[:title]
            embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: @masterqueue[event.server.id].first[:thumbnail_url])
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{@masterqueue[event.server.id].first[:like_count]} Likes, #{@masterqueue[event.server.id].first[:dislike_count]} Dislikes, #{@masterqueue[event.server.id].first[:view_count]} Views, #{@masterqueue[event.server.id].first[:comment_count]} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
            embed.url = @masterqueue[event.server.id].first[:url]
            embed.color = 0x89DA72
          end
          event.bot.listening = @masterqueue[event.server.id].first[:title]
          event.voice.play_file(@masterqueue[event.server.id].first[:location])

          emb.delete

          # File.delete(@masterqueue[event.server.id].first[:location])
          break if @masterqueue[event.server.id].empty?
          @masterqueue[event.server.id].shift unless @masterqueue[event.server.id].first[:loop]
        end
      end
      nil
    end

  end
end
