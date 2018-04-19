module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:sinfo, type: :General, description: 'Get a list of statistics about the server the command is run in.') do |event|
      event.channel.send_embed do |embed|
        embed.title = 'Server Info'
        embed.add_field(name: 'Server Name', value: event.server.name, inline: true)
        embed.add_field(name: 'Server ID', value: event.server.id, inline: true)
        embed.add_field(name: 'Server Region', value: event.server.region, inline: true)
        embed.add_field(name: 'Server Owner', value: "#{event.server.owner.name}\##{event.server.owner.discrim}", inline: true)
        embed.add_field(name: 'Total Member Count', value: event.server.members.count, inline: true)
        embed.add_field(name: 'Total Channel Count', value: event.server.channels.count, inline: true)
        embed.add_field(name: 'Text Channels', value: event.server.text_channels.count, inline: true)
        embed.add_field(name: 'Voice Channels', value: event.server.voice_channels.count, inline: true)
        embed.add_field(name: 'Roles', value: event.server.roles.count, inline: true)
        embed.add_field(name: 'Bans', value: event.server.bans.count, inline: true)
        embed.add_field(name: 'Created at', value: "#{event.server.creation_time.getutc.asctime} UTC", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.server.icon_url)
        embed.color = $normalcolor
      end
    end
  end
end
