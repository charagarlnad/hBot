module Bot::DiscordCommands
  module Music
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new(Array.new)
    command :queue do |event|
      event.respond 'I am not in voice.' if event.voice == nil
      next nil if event.voice == nil
      event.channel.send_embed do |embed|
        @masterqueue[event.server.id][0..24].each do |video|
          embed.add_field(name: video.title, value: video.description)
        end
        embed.title = '**hBot Queue**'
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: @masterqueue[event.server.id].count.to_s + " videos in queue.")
        embed.color = 7440596
      end
    end

    def self.addQueue(video, event)
      @masterqueue[event.server.id] << video
      if !(File.file?('data/musiccache/' + video.title + '.mp3'))
        Thread.new do
          system("youtube-dl --format best --recode-video mp4 -o \"data/musiccache/#{video.title}.%(ext)s\" https://www.youtube.com/watch?v=#{video.id}")
        end
      end
      self.playMusic(event)
    end

    def self.playMusic(event)
      if @masterqueue[event.server.id].length == 1
        until @masterqueue[event.server.id].size == 0
          until File.exists?('data/musiccache/' + @masterqueue[event.server.id].first.title + '.mp4')
            sleep(0.1)
          end
          event.voice.play_file('data/musiccache/' + @masterqueue[event.server.id].first.title + '.mp4')
          @masterqueue[event.server.id].shift
          #File.delete('data/musiccache/' + @masterqueue[event.server.id]0.title + '.mp3')
        end
      end
    end
  end
end