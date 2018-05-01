module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    cows =
      Dir['/usr/share/cowsay/cows/*.cow'].each do |cow|
        cow.gsub!('/usr/share/cowsay/cows/', '').gsub!('.cow', '')
      end
    command(:cowsay, type: :Fun, description: 'Cowsay [**X**].') do |event, cow, *text|
      if cow.nil?
        event.send_embed do |embed|
          embed.title = 'Cowsay cows'
          embed.description = cows.join("\n")
        end
      elsif !cows.include?(cow)
        event.channel.send_embed do |embed|
          text << ' ' if text.empty?
          response = `cowsay "#{cow + ' ' + text.join(' ')}"`
          embed.description = "```#{response}```"
        end
      else
        event.channel.send_embed do |embed|
          text << ' ' if text.empty?
          response = `cowsay -f #{cow} "#{text.join(' ')}"`
          embed.description = "```#{response}```"
        end
      end
      nil
    end
  end
end
