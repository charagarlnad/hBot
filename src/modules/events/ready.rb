module Bot::DiscordEvents
  # This event is processed each time the bot succesfully connects to discord.
  module Ready
    extend Discordrb::EventContainer
    ready do |event|
      puts "Imgbot is ready with #{event.bot.servers.count} servers and #{event.bot.users.count} users!"
      event.bot.stream('i.help', 'https://www.twitch.tv/vinesauce')

      bot.servers.each do |server|
        server.voice.destroy if server.voice != nil # fix for bot cache bug
      end

    end
  end
end
