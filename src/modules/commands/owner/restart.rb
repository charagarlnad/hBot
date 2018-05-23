module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:restart, type: :Owner, description: 'Restart the bot.', requirements: [:owner]) do |event|
      passcode = rand(1000..9999)
      event.respond "Please type the following passcode to restart the bot: #{passcode}"
      event.user.await(:"exit#{event.user.id}") do |await_event|
        if await_event.message.content.to_i == passcode
          event.respond 'Bot is restarting.'
          puts "Restart initiated by #{await_event.user.name}."
          exec('bundle exec ruby run.rb')
        else
          event.respond 'Cancelling restart.'
        end
        true
      end
      nil
    end
  end
end
