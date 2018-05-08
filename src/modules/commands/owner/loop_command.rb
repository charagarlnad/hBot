module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:loop_command, type: :Owner, description: 'Loop a command [**X**] times.', requirements: [:owner, :has_arguments, :arguments_is_int]) do |event, amount, command, *args|
      if command.nil?
        event.send_timed_embed do |embed|
          embed.description = 'A command is required.'
        end
        break
      end
      amount.to_i.times do
        event.bot.execute_command(command.to_sym, event, args.join(' '))
      end
    end
  end
end
