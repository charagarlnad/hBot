module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    @masterqueue = Hash.new(Array.new)
    @voicebots = Hash.new
    command :queue do |event|
      event.respond 'I am not in voice.' if @voicebots[event.server.id] = nil
      next nil if @voicebots[event.server.id] = nil
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
      puts 'a'
      if !(File.file?('data/musiccache/' + video.title + '.mp3'))
        puts 'b'
        system("youtube-dl --format best --extract-audio --audio-format mp3 -o \"data/musiccache/#{video.title}.%(ext)s\" https://www.youtube.com/watch?v=#{video.id}")
      end
      puts 'c'
      self.playMusic(event)
    end

    def self.playMusic(event)
      puts 'd'
      if @masterqueue[event.server.id].first != nil && !(@voicebots[event.server.id].playing?)
        puts 'e'
        Thread.new do
          puts 'f'
          @voicebots[event.server.id].play_file('data/musiccache/' + @masterqueue[event.server.id].first.title + '.mp3')
          #File.delete('data/musiccache/' + @masterqueue[event.server.id]0.title + '.mp3')
          @masterqueue[event.server.id].shift
        end
      end
    end
  end
end