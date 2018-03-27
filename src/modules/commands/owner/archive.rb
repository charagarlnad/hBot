module Bot::DiscordCommands
    module Eval
      extend Discordrb::Commands::CommandContainer
      bot.command(:archive) do |event|
        if event.user.id == 123927345307451392
          channel = event.message.channel.id
          arch = event.bot.channel(channel).history(100, event.message.id) # amount, latest message in channel
          file = File.open("{event.message.channel.name}.txt", 'a+')
          arch.each { |word| file.write("#{word.author.name}\##{word.author.discriminator}\n#{word.content}\n#{word.timestamp}\n") }
          x = arch.last.id
      
          until arch.size != 100
            arch = event.bot.channel(channel).history(100, x)
            x = arch.last.id
            arch.each { |word| file.write("#{word.author.name}\##{word.author.discriminator}\n#{word.content}\n#{word.timestamp}\n") }
          end
          file.close
        end
      end
    end
end