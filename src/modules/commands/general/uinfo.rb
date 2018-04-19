module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:uinfo, type: :General, description: 'Get a list of statistics about the user that runs the command.') do |event|
      # Allow mentions of other users
      event.channel.send_embed do |embed|
        embed.title = 'User Info'
        embed.add_field(name: 'Name#Discrim', value: "#{event.user.name}\##{event.user.discrim}", inline: true)
        embed.add_field(name: 'Status', value: event.user.status, inline: true)
        embed.add_field(name: 'Currently Playing', value: event.user.game, inline: true)
        embed.add_field(name: 'Created at', value: "#{event.user.creation_time.getutc.asctime} UTC", inline: true)
        embed.add_field(name: 'Joined server at', value: "#{event.user.joined_at.getutc.asctime} UTC", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: event.user.avatar_url)
        embed.color = $normalcolor
      end
    end
  end
end
