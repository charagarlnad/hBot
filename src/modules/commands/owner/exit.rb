module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:exit, type: :Owner, description: 'Turn off the bot.', requirements: [:owner]) do |event|
      passcode = rand(1000..9999)
      event.respond "Please type the following passcode to shutdown the bot: #{passcode}"
      event.user.await(:"exit#{event.user.id}") do |await_event|
        if await_event.message.content.to_i == passcode
          event.respond 'Bot is shutting down.'
          puts "Shutdown initiated by #{await_event.user.name}."
          exit!
        else
          event.respond 'Cancelling shutdown.'
        end
        true
      end
      nil
    end
  end
end
