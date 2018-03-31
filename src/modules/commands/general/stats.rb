module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    starttime = Time.now
    command :stats do |event|
      ping = ((Time.now - event.timestamp) * 1000).to_i

      total_size = 0
      Dir["data/musiccache/*"].each do |f|
        total_size += File.size(f) if File.file?(f) && File.size?(f)
      end

      event.channel.send_embed do |embed|
        embed.title = "Imgbot Stats"
        embed.add_field(name: "Uptime", value: seconds_to_units((Time.now - starttime).to_i), inline: true)
        embed.add_field(name: "Ping", value: "#{ping}ms", inline: true)
        embed.add_field(name: "Music cache size", value: Filesize.from(total_size.to_s + ' B').pretty, inline: true)
        embed.add_field(name: "Users / Servers", value: "#{event.bot.users.count} / #{event.bot.servers.count}", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url:event.bot.profile.avatar_url)  
        embed.color = 0x7289DA
      end
      
    end

    def self.seconds_to_units(seconds)
      '%d days, %d hours, %d minutes, %d seconds' %
        # the .reverse lets us put the larger units first for readability
        [24,60,60].reverse.inject([seconds]) {|result, unitsize|
          result[0,0] = result.shift.divmod(unitsize)
          result
        }
    end

  end
end
 