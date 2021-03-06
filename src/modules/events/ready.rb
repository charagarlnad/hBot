module Bot::DiscordEvents
  # This event is processed each time the bot succesfully connects to discord.
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
      puts "hBot is ready with #{event.bot.servers.count} servers and #{event.bot.users.count} users!"
      event.bot.stream("#{event.bot.prefix}help", 'https://www.twitch.tv/vinesauce')
    end
  end
end
