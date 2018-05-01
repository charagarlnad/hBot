module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    type = ['trivia', 'math', 'date', 'year']
    command(:numfact, type: :Fun, description: 'Get a random fact about a [**Number**].') do |event, num|
      num = 'random' unless num.i?
      fact = JSON.parse(Net::HTTP.get(URI("http://numbersapi.com/#{num}/#{type.sample}?json"))).symbolize_keys
      event.channel.send_embed do |embed|
        embed.title = fact[:number]
        embed.description = fact[:text]
      end
      nil
    end
  end
end
