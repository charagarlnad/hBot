module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    porn = Magick::Image.read('data/command_data/porn/source.png').first
    porn_mask = Magick::Image.read('data/command_data/porn/mask.png').first.negate
    porn_mask.matte = false
    command(:porn, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.scale(846, 478)

      append_image.composite!(porn_mask, Magick::CenterGravity, -45, -120, Magick::CopyOpacityCompositeOp)
      result = porn.composite(append_image, Magick::CenterGravity, 45, 120, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
