module Bot::DiscordCommands
  module General
      extend Discordrb::Commands::CommandContainer
      command :help2 do |event|
        event.channel.send_embed do |embed|
          Dir["src/modules/commands/**"].each do |base|
            commandarr = Dir.children(base).map { |prepend| "#{event.bot.prefix}#{prepend}" } #ruby 2.3 or above boys
            embed.add_field(name: base, value: commandarr.join("\n").gsub('.rb', ''))
          end
          embed.title = '**Imgbot (click me to invite me to your server!)**'
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
          embed.url = event.bot.invite_url
          embed.color = 7440596
        end
      end
  end
end