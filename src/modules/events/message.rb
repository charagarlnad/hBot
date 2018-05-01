module Bot::DiscordEvents
  module Message
    extend Discordrb::EventContainer
    message do
      Bot.messages += 1
      nil
    end
  end
end
