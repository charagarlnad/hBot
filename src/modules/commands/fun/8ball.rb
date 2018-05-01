module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    responses =
      [
        'It is certain',
        'It is decidedly so',
        'Without a doubt',
        'Yes definitely',
        'You may rely on it',
        'As I see it, yes',
        'Most likely',
        'Outlook good',
        'Yes',
        'Signs point to yes',
        'Reply hazy try again',
        'Ask again later',
        'Better not tell you now',
        'Cannot predict now',
        'Concentrate and ask again',
        'Don\'t count on it',
        'My reply is no',
        'My sources say no',
        'Outlook not so good',
        'Very doubtful'
      ]
    command(:'8ball', type: :Fun, description: 'Ask the magic 8 ball a [**question**].') do |event|
      event.channel.send_embed do |embed|
        embed.description = responses.sample
      end
      nil
    end
  end
end
