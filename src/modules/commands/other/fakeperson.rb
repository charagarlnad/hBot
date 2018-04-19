module Bot::DiscordCommands
  module Other
    extend Discordrb::Commands::CommandContainer
    command(:fakeperson, type: :Other, description: 'Generate a random fake person.') do |event|
      event.channel.send_embed do |embed|
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Faker::Avatar.image)
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: Faker::Name.name)
        embed.color = $defaultcolor

        embed.add_field(name: 'Address', value: "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state} #{Faker::Address.zip}", inline: true)
        embed.add_field(name: 'Profession', value: Faker::Company.profession.capitalize, inline: true)
        embed.add_field(name: 'Email', value: Faker::Internet.free_email, inline: true)
        embed.add_field(name: 'Cell Phone', value: Faker::PhoneNumber.cell_phone, inline: true)
        embed.add_field(name: 'IPv4', value: Faker::Internet.ip_v4_address, inline: true)
        embed.add_field(name: 'IPv6', value: Faker::Internet.ip_v6_address, inline: true)
        embed.add_field(name: 'Bitcoin', value: Faker::Bitcoin.address, inline: true)
        embed.add_field(name: 'Favorite Color', value: Faker::Color.color_name.capitalize, inline: true)
      end

      nil
    end
  end
end
