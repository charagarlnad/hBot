module Bot::DiscordCommands
  module Owner
    extend Discordrb::Commands::CommandContainer
    command(:eval, type: :Owner, description: 'Evaluate [**Ruby code**] on the bot.', requirements: [:owner]) do |event, *code|
      output = (eval code.join(' ')).to_s
      event.send_embed do |embed|
        embed.title = "#{$ruby} Eval"
        embed.description =
          if output.size <= 2000
            output
          else
            puts output
            'Output too long, check console for details.'
          end
      end
    rescue => error
      event.send_embed do |embed|
        embed.title =
          if error.inspect.size <= 2000
            error.inspect
          else
            puts error.inspect
            'Error inspect too long, check console for details.'
          end
        embed.description =
          if error.backtrace.join("\n").size <= 2000
            "```#{error.backtrace.join("\n")}```"
          else
            puts error.backtrace.join("\n")
            'Backtrace too long, check console for details.'
          end
      end
    end
  end
end
