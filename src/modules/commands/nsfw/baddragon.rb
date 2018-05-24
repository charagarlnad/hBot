module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    bd_client = BadASS::Client.new
    command(:baddragon, type: :NSFW, requirements: [:nsfw], description: 'Search Bad Dragon for the current toys, overview, or a random toy.') do |event, *request|
      if request.empty?
        event.send_embed do |embed|
          embed.description = 'You must supply at least 1 argument to this command: amount/count, overview, random, or a search.'
        end
      elsif request.first == 'amount' || request.first == 'count'
        event.send_embed do |embed|
          embed.description = "Bad Dragon has #{bd_client.drops.count} premade toy#{bd_client.drops.count.to_i > 1 ? 's' : ''}."
        end
      elsif request.first == 'overview'
        toys = {}
        bd_client.drops.each do |toy|
          if toys[toy.name]
            toys[toy.name] += 1
          else
            toys[toy.name] = 1
          end
        end
        event.send_embed do |embed|
          text = ''
          toys.each do |toy, amount|
            text += "#{toy}: #{amount}\n"
          end
          embed.description = text
        end
      else
        toy =
          if request.first == 'random'
            bd_client.drops.sample
          else
            bd_client.drops.select { |bdtoy| bdtoy.name.downcase.include?(request.join(' ').downcase) }.sample
          end

        if toy
          event.send_embed do |embed|
            embed.add_field(name: 'Toy', value: toy.name)
            embed.add_field(name: 'Firmness', value: toy.firmness)
            embed.add_field(name: 'Size', value: toy.size.capitalize)
            embed.add_field(name: 'Price', value: "$#{toy.price}")
            embed.add_field(name: 'Flop Reason', value: toy.flop_reason) unless toy.flop_reason.empty?
            embed.add_field(name: 'Suction Cup', value: '✓') if toy.suction_cup?
            embed.add_field(name: 'Cumtube', value: '✓') if toy.cumtube?
            embed.image = Discordrb::Webhooks::EmbedImage.new(url: toy.images.empty? ? 'https://bad-dragon.com/static-media/images/image-not-found.jpg' : toy.images.first)
          end
        else
          event.send_embed do |embed|
            embed.description = 'No toys found.'
          end
        end
      end
    end
  end
end
