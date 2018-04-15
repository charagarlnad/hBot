module Bot::DiscordCommands
    module Eval
      extend Discordrb::Commands::CommandContainer
      command(:archive, type: :Owner, description: 'Archive all the messages in the channel the command is executed in.') do |event|
        if event.user.id == 123927345307451392
          event.respond "Ok, archiving."
          channel = event.message.channel.id
          arch = event.bot.channel(channel).history(100, event.message.id) # amount, latest message in channel
          file = File.open("#{event.message.channel.name}.txt", 'a+')
          arch.each { |word| file.write("#{word.author.name}\##{word.author.discriminator}\n#{word.content}\n#{word.timestamp}\n") }
          x = arch.last.id
      
          until arch.size != 100
            arch = event.bot.channel(channel).history(100, x)
            x = arch.last.id
            arch.each { |word| file.write("#{word.author.name}\##{word.author.discriminator}\n#{word.content}\n#{word.timestamp}\n") }
          end
          file.close
          event.respond "Archiving done, output file: #{event.message.channel.name}.txt"
        end
      end
    end
end