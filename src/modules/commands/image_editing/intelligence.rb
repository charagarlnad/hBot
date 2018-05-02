module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    intelligence = Magick::Image.read('data/command_data/intelligence/source.png').first
    command(:intelligence, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.resize_to_fit(662, 512)

      result = intelligence.composite(append_image, Magick::CenterGravity, 0, 215, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
