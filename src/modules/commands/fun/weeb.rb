module Bot::DiscordCommands
  module Fun
    extend Discordrb::Commands::CommandContainer
    command(:weeb, type: :Fun, requirements: [:has_arguments], description: 'See how much of a weeb [**X**] is.') do |event, mention|
      event.channel.send_embed do |embed|
        embed.description = "#{mention} is #{Random.new(Digest::MD5.hexdigest(mention).to_i(16)).rand(100)}% weeb."
      end
      nil
    end
  end
end
