module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new()
    command :queue do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next nil if event.voice == nil
      event.respond 'There is nothing in the queue.' if @masterqueue[event.server.id] == nil
      next nil if @masterqueue[event.server.id] == nil
      event.respond 'There is nothing in the queue.' if @masterqueue[event.server.id].size == 0
      next nil if @masterqueue[event.server.id].size == 0

      emb = event.channel.send_embed do |embed|
        @masterqueue[event.server.id][0..24].each do |videohash|
          embed.add_field(name: videohash[:video].title + ', Length: ' + videohash[:video].length, value: videohash[:video].description)
        end
        embed.title = "**hBot Queue** - Video time: #{Time.at(event.voice.stream_time.to_i).utc.strftime("%H:%M:%S")}/#{@masterqueue[event.server.id].first[:video].length}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)  
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: @masterqueue[event.server.id].count.to_s + " videos in queue.")
        embed.color = 7440596
      end

      Thread.new do
        sleep(32) 
        emb.delete
      end
      nil

    end

    def self.addVideo(event, video)
      @masterqueue[event.server.id] = Array.new if @masterqueue[event.server.id] == nil
      videohash = Hash.new
      videohash[:video] = video
      videohash[:location] = 'data/musiccache/' + `youtube-dl --restrict-filenames --get-filename -o "%(title)s" https://www.youtube.com/watch?v=#{video.id}`.chomp + '.mp4'

      if !(File.file?(videohash[:location]))
        videohash[:downloader] = Thread.new do
          system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" https://www.youtube.com/watch?v=#{video.id}")
        end
      end

      @masterqueue[event.server.id] << videohash
      startPlayer(event) if @masterqueue[event.server.id].size == 1
    end

    def self.addBassBoostVideo(event, video)
      @masterqueue[event.server.id] = Array.new if @masterqueue[event.server.id] == nil
      videohash = Hash.new
      videohash[:video] = video
      videohash[:location] = 'data/musiccache/bassboost-' + `youtube-dl --restrict-filenames --get-filename -o "%(title)s" https://www.youtube.com/watch?v=#{video.id}`.chomp + '.mp4'

      if !(File.file?(videohash[:location]))
        videohash[:downloader] = Thread.new do
          if !(File.file?(videohash[:location].gsub('bassboost-', '')))
            system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" https://www.youtube.com/watch?v=#{video.id}")
          end
          system("ffmpeg -i #{videohash[:location].gsub('bassboost-', '')} -af bass=g=20:f=200 #{videohash[:location]}")
        end
      end

      @masterqueue[event.server.id] << videohash
      startPlayer(event) if @masterqueue[event.server.id].size == 1
    end

    def self.startPlayer(event)
      Thread.new do
        until @masterqueue[event.server.id].size == 0 
          if @masterqueue[event.server.id].first[:downloader] != nil
            until @masterqueue[event.server.id].first[:downloader].alive? == false
              sleep(0.1)
            end
          end
          emb = event.channel.send_embed('Now playing:') do |embed|
            embed.description = @masterqueue[event.server.id].first[:video].description
            embed.title = @masterqueue[event.server.id].first[:video].title
            embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: @masterqueue[event.server.id].first[:video].thumbnail_url)  
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{@masterqueue[event.server.id].first[:video].like_count} Likes, #{@masterqueue[event.server.id].first[:video].dislike_count} Dislikes, #{@masterqueue[event.server.id].first[:video].view_count} Views, #{@masterqueue[event.server.id].first[:video].comment_count} Comments", icon_url: 'http://www.stickpng.com/assets/images/580b57fcd9996e24bc43c545.png')
            embed.url = "https://www.youtube.com/watch?v=" + @masterqueue[event.server.id].first[:video].id
            embed.color = 0x89DA72
          end
          event.voice.play_file(@masterqueue[event.server.id].first[:location])
          emb.delete
          #File.delete(@masterqueue[event.server.id].first[:location])
          @masterqueue[event.server.id].shift
        end
      end
      nil
    end

  end
end