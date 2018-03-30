module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new()
    @downloaders = Hash.new()
    command :queue do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next nil if event.voice == nil
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
      @masterqueue[event.server.id] << video
      if !(File.file?('data/musiccache/' + `youtube-dl --restrict-filenames --get-filename -o "%(title)s" https://www.youtube.com/watch?v=#{video.id}`.chomp + '.mp4'))
        @downloaders[video.id] = Thread.new do
          system("youtube-dl --restrict-filenames --format best --recode-video mp4 -o \"data/musiccache/%(title)s.%(ext)s\" https://www.youtube.com/watch?v=#{video.id}")
        end
      end
      startPlayer(event) if @masterqueue[event.server.id].size == 1
    end

    def self.startPlayer(event)
      Thread.new do
        until @masterqueue[event.server.id].size == 0 
          if @downloaders[@masterqueue[event.server.id].first.id] != nil
            until @downloaders[@masterqueue[event.server.id].first.id].alive? == false # Safe Navigation Operator
              sleep(0.1)
            end
          end
          event.voice.play_file('data/musiccache/' + `youtube-dl --restrict-filenames --get-filename -o "%(title)s" https://www.youtube.com/watch?v=#{@masterqueue[event.server.id].first.id}`.chomp + '.mp4')
          @masterqueue[event.server.id].shift
          #File.delete('data/musiccache/' + @masterqueue[event.server.id]0.title + '.mp3')
        end
      end
      nil
    end

  end
end