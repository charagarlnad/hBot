module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    if File.file?('data/blacklist.txt')
      File.read('data/blacklist.txt').each_line { |user| Bot::BOT.ignore_user(user) }
    end
    command(:blacklist, type: :Owner, description: 'Blacklist a user from the bot.') do |event, mention|
      if event.user.id == 123927345307451392
        event.bot.ignore_user(event.bot.parse_mention(mention).id)
        File.open('data/blacklist.txt', 'w') { |f| f.write(event.bot.ignored_ids.to_a.join("\n")) }
      end
    end
  end
end
