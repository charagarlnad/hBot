module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    starttime = Time.now
    command(:stats, type: :General, description: 'Get a list of statistics about the bot.') do |event|
      ping = ((Time.now - event.timestamp) * 1000).to_i

      total_size = 0
      Dir['data/musiccache/*'].each do |f|
        total_size += File.size(f) if File.file?(f) && File.size?(f)
      end

      event.channel.send_embed do |embed|
        embed.title = 'hBot Stats'
        embed.add_field(name: 'Uptime', value: seconds_to_units((Time.now - starttime).to_i), inline: true)
        embed.add_field(name: 'Ping', value: "#{ping}ms", inline: true)
        embed.add_field(name: 'Music cache size', value: Filesize.from(total_size.to_s + ' B').pretty, inline: true)
        embed.add_field(name: 'Users / Servers', value: "#{event.bot.users.count} / #{event.bot.servers.count}", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
      end
    end

    def self.seconds_to_units(secs)
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map do |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{name}"
        end
      end.compact.reverse.join(' ')
    end
  end
end
