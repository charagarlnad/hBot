module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:uinfo, type: :General, description: 'Get a list of statistics about the user that runs the command.') do |event, mention|
      # Allow just typing name without a mention, and rewrite into a method.
      user =
        if mention&.match?(/<@!?\d{10,}>/)
          event.bot.parse_mention(mention).on(event.server)
        else
          event.user
        end
      event.channel.send_embed do |embed|
        embed.title = 'User Info'
        embed.add_field(name: 'Name#Discrim', value: "#{user.name}\##{user.discrim}", inline: true)
        embed.add_field(name: 'Status', value: user.status, inline: true)
        embed.add_field(name: 'Currently Playing', value: user.game || 'N/A', inline: true)
        embed.add_field(name: 'Created at', value: "#{user.creation_time.getutc.asctime} UTC", inline: true)
        embed.add_field(name: 'Joined server at', value: "#{user.joined_at.getutc.asctime} UTC", inline: true)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: user.avatar_url)
      end
    end
  end
end
