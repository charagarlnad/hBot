module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:choose, type: :Fun, requirements: [:has_arguments], description: 'Choose between [**Multiple choices**] (use | to split choices)') do |event, *choices|
      finalchoices = choices.join(' ').split('|')
      event.channel.send_embed do |embed|
        embed.description = event.user.mention + ', I think you should: ' + finalchoices.sample
      end
      nil
    end
  end
end
