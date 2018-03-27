module Bot::DiscordCommands
  module Games
    extend Discordrb::Commands::CommandContainer
    command :sheriff do |event, emoji|
      event.respond "⠀ ⠀ ⠀  🤠\n　   #{emoji}#{emoji}#{emoji}\n    #{emoji}   #{emoji}　#{emoji}\n   👇   #{emoji}#{emoji} 👇\n  　  #{emoji}　#{emoji}\n　   #{emoji}　 #{emoji}\n　   👢     👢\nhowdy. i'm the sheriff of #{emoji}"
    end
  end
end
