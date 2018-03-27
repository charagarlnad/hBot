module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:eval, help_available: false) do |event, *code|
      #make this read from a list of owners xd
      if event.author.id == 123927345307451392
        begin
          eval code.join(' ')
        rescue => error
          event << "#{error.class}; #{error.message}"
        end
      end
    end
  end
end
