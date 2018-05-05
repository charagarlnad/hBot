module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    command(:invite, type: :General, description: 'Get a invite to add the bot to your server.') do |event|
      event.channel.send_embed do |embed|
        embed.title = 'To invite hBot to your server, click me.'
        embed.url = event.bot.invite_url(permission_bits: 8)
      end
    end
  end
end
