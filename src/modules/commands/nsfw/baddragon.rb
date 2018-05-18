module Bot::DiscordCommands
  module General
    extend Discordrb::Commands::CommandContainer
    # https://bad-dragon.com/api/colors
    # https://bad-dragon.com/api/sales
    # https://staging.bad-dragon.com/api/inventory-toys?price[min]=0&price[max]=300&noAccessories=false&cumtube=false&suctionCup=false&sort[field]=price&&sort[direction]=asc&page=2&limit=60
    # https://bad-dragon.com/shop/clearance?page=1
    firmnesses = { '2' => 'Extra Soft', '3' => 'Soft', '5' => 'Medium', '8' => 'Firm' }

    baddragon_skus = {}
    JSON.parse(Net::HTTP.get(URI('https://bad-dragon.com/api/inventory-toy/product-list'))).each do |toy|
      baddragon_skus[toy['sku']] = toy['name']
    end

    Thread.new do
      loop do
        @toys_finished = false
        page = 1
        @toys = []
        loop do
          newtoys = JSON.parse(Net::HTTP.get(URI("https://bad-dragon.com/api/inventory-toys?price[min]=0&price[max]=300&noAccessories=false&cumtube=false&suctionCup=false&sort[field]=price&&sort[direction]=asc&page=#{page}&limit=60")))
          page += 1
          @toys.concat(newtoys['toys'])
          break if page > newtoys['totalPages']
        end
        puts 'Bad Dragon toy list obtained.'
        @toys_finished = true
        sleep(600)
      end
    end

    def self.bd_toys
      sleep(0.1) until @toys_finished
      @toys
    end

    command(:baddragon, type: :NSFW, requirements: [:nsfw], description: 'Search Bad Dragon for the current toys, overview, or a random toy.') do |event, *request|
      if request.empty?
        event.send_embed do |embed|
          embed.description = 'You must supply at least 1 argument to this command: amount/count, overview, random, or a search.'
        end
      elsif request.first == 'amount' || request.first == 'count'
        event.send_embed do |embed|
          embed.description = "Bad Dragon has #{bd_toys.count} premade toy#{bd_toys.count.to_i > 1 ? 's' : ''}."
        end
      elsif request.first == 'overview'
        toys = {}
        bd_toys.each do |toy|
          if toys[toy['sku']]
            toys[toy['sku']] += 1
          else
            toys[toy['sku']] = 1
          end
        end
        event.send_embed do |embed|
          text = ''
          toys.each do |toy, amount|
            text += "#{baddragon_skus[toy]}: #{amount}\n"
          end
          embed.description = text
        end
      else
        toy =
          if request.first == 'random'
            bd_toys.sample
          else
            bd_toys.select { |bdtoy| baddragon_skus[bdtoy['sku']].downcase.include?(request.join(' ').downcase) }.sample
          end

        if toy
          event.send_embed do |embed|
            embed.add_field(name: 'Toy', value: baddragon_skus[toy['sku']])
            embed.add_field(name: 'Firmness', value: firmnesses[toy['firmness']])
            embed.add_field(name: 'Size', value: toy['size'].capitalize)
            embed.add_field(name: 'Price', value: "$#{toy['price']}")
            embed.add_field(name: 'Flop Reason', value: toy['flop_reason']) unless toy['flop_reason'].empty?
            embed.add_field(name: 'Suction Cup', value: '✓') if toy['suction_cup'] == 1
            embed.add_field(name: 'Cumtube', value: '✓') if toy['cumtube'] == 1
            embed.image = Discordrb::Webhooks::EmbedImage.new(url: toy['images'].empty? ? 'https://bad-dragon.com/static-media/images/image-not-found.jpg' : toy['images'].first['fullFilename'])
            # The API seems to not report colors correctly sometimes so maybe dont use the color.
            # embed.color = toy['color1'] unless toy['color1'] == '000000'
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
