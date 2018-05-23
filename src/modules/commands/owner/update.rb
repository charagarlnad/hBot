module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:update, type: :Owner, description: 'Update and restart the bot.', requirements: [:owner]) do |event|
      passcode = rand(1000..9999)
      event.respond "Please type the following passcode to update the bot: #{passcode}"
      event.user.await(:"exit#{event.user.id}") do |await_event|
        if await_event.message.content.to_i == passcode
          system('git pull')
          system('bundle install')
          event.respond 'Bot is restarting to update.'
          puts "Update initiated by #{await_event.user.name}."
          exec('bundle exec ruby run.rb')
        else
          event.respond 'Cancelling update.'
        end
        true
      end
      nil
    end
  end
end
