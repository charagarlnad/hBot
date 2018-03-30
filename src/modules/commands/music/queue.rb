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

      event.channel.send_embed do |embed|
        @masterqueue[event.server.id][0..24].each do |video|
          embed.add_field(name: video.title + ', Length: ' + video.length, value: video.description)
        end
        embed.title = "**hBot Queue** - Video time: #{Time.at(event.voice.stream_time.to_i).utc.strftime("%H:%M:%S")}/#{@masterqueue[event.server.id].first.length}"
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)  
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: @masterqueue[event.server.id].count.to_s + " videos in queue.")
        embed.color = 7440596
      end
    end

    def self.addVideo(event, video)
      @masterqueue[event.server.id] = Array.new
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

    def self.startPlayer(event)
      Thread.new do
        until @masterqueue[event.server.id].size == 0 
          if @masterqueue[event.server.id].first[:downloader] != nil
            until @masterqueue[event.server.id].first[:downloader].alive? == false
              sleep(0.1)
            end
          end
          event.voice.play_file(@masterqueue[event.server.id].first[:location])
          #File.delete(@masterqueue[event.server.id].first[:location])
          @masterqueue[event.server.id].shift
        end
      end
      nil
    end

  end
end