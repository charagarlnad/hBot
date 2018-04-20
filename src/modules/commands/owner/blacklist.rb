module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    File.new('data/blacklist.txt', 'w') unless File.file?('data/blacklist.txt')
    File.read('data/blacklist.txt').each_line { |user| Bot::BOT.ignore_user(user) }
    command(:blacklist, type: :Owner, description: 'Blacklist a user from the bot.', requirements: [:owner]) do |event, mention|
      user = event.bot.parse_mention(mention)
      event.send_embed do |embed|
        embed.description =
          if mention.nil?
            users = []
            event.bot.ignored_ids.to_a.each do |ignored_user|
              users << event.bot.parse_mention("<@#{ignored_user}>").name
            end
            users.join("\n")
          elsif event.bot.ignored_ids.to_a.include? user.id
            event.bot.unignore_user(user.id)
            "Ok, removed #{user.name} from the blacklist."
          else
            event.bot.ignore_user(user.id)
            "Ok, added #{user.name} to the blacklist."
          end
        embed.color = $normalcolor
      end
      File.open('data/blacklist.txt', 'w') { |f| f.write(event.bot.ignored_ids.to_a.join("\n")) }
      nil
    end
  end
end
