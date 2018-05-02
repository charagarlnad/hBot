module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    cows =
      Dir['/usr/share/cowsay/cows/*.cow'].each do |cow|
        cow.gsub!('/usr/share/cowsay/cows/', '').gsub!('.cow', '')
      end
    command(:cowsay, type: :Fun, description: 'Cowsay [**X**].') do |event, *text|
      if text.empty?
        event.send_embed do |embed|
          embed.title = 'Cowsay cows'
          embed.description = cows.join("\n")
        end
      elsif cows.include?(text.first)
        text << ' ' if text.size == 1
        event.channel.send_embed do |embed|
          response = IO.popen(['cowsay', '-f', text.shift, text.join(' ')]).read
          embed.description = "```#{response}```"
        end
      else
        event.channel.send_embed do |embed|
          response = IO.popen(['cowsay', text.join(' ')]).read
          embed.description = "```#{response}```"
        end
      end
      nil
    end
  end
end
