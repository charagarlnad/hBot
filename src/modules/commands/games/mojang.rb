module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    command(:mojang, type: :Games, description: 'Get status for Mojang servers.') do |event|
      statuses = JSON.parse(RestClient.get('https://status.mojang.com/check')).reduce({}, :merge)
      messages = {}
      statuses.each do |site, status|
        type =
          case site
          when 'minecraft.net' then 'Minecraft'
          when 'session.minecraft.net' then 'Minecraft Sessions'
          when 'account.mojang.com' then 'Mojang Account'
          when 'authserver.mojang.com' then 'Mojang Auth Server'
          when 'sessionserver.mojang.com' then 'Mojang Sessions'
          when 'api.mojang.com' then 'Mojang API'
          when 'textures.minecraft.net' then 'Minecraft Textures'
          when 'mojang.com' then 'Mojang'
          else site
          end
        resp =
          case status
          when 'green' then '✅'
          when 'yellow' then '⚠'
          when 'red' then '❌'
          else '❓'
          end

        messages[type] = resp
      end
      event.channel.send_embed do |embed|
        embed.color = $normalcolor
        embed.url = 'https://twitter.com/mojangstatus'
        embed.description = '```Current Mojang Stats are:```'

        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.bot.profile.avatar_url)
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'Mojang Stat Checker', url: 'https://twitter.com/mojangstatus', icon_url: event.bot.profile.avatar_url)

        messages.each do |type, resp|
          embed.add_field(name: type, value: resp, inline: true)
        end
      end

      nil
    end
  end
end
