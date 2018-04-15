module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    command(:mcserver, type: :Games, description: 'Get status for a [**Minecraft Server**].') do |event, server|
      info = JSON.parse(RestClient.get("https://mc-api.net/v3/server/ping/#{server}"))
      if !info['error'].nil?
        event.channel.send_embed do |embed|
          embed.description = 'A error occured (is the server online?)'
          embed.color = 0x7289DA
        end
      else
        event.channel.send_embed do |embed|
          embed.title = "Server info for #{server}"
          embed.add_field(name: 'Players', inline: true, value: "#{info['players']['online']}/#{info['players']['max']}")
          embed.add_field(name: 'Version', inline: true, value: info['version']['name'])
          embed.add_field(name: 'Ping', inline: true, value: info['took'].round.to_s + 'ms')
          embed.add_field(name: 'Mods', inline: true, value: info['modinfo']['modList'].size) if !info['modinfo']['modList'].nil? && !info['modinfo']['modList'].empty?
          embed.add_field(name: 'MOTD', inline: true, value: info['description']['text']) if !info['description']['text'].nil? && !info['description']['text'].empty?
          embed.color = 0x7289DA
        end
      end
    end
  end
end
