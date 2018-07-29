module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    proto = Magick::Image.read('data/command_data/proto/proto.png').first
    proto_mask = Magick::Image.read('data/command_data/proto/mask.png').first.negate
    proto_mask.matte = false
    command(:proto, type: :'Image Editing') do |event|
      # possibly make below use actual size of image and not scale to 350, 350 using a array of the x and y size and .min and .max it
      append_image = Magick::Image.from_blob(event.image_source).first.scale(350, 350)

      append_image.composite!(proto_mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
      result = proto.composite(append_image, Magick::CenterGravity, 0, -200, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
