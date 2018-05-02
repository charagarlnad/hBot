module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    gone = Magick::Image.read('data/command_data/gone/source.png').first
    gone_mask = Magick::Image.read('data/command_data/gone/mask.png').first.negate
    gone_mask.matte = false
    command(:gone, type: :'Image Editing') do |event|
      # maybe optimize by making 1 append image with 3 insside of it on 1 level and move them to the correct spots
      append_image = Magick::Image.from_blob(event.image_source).first.scale(410, 410)

      append_image1 = append_image.composite(gone_mask, Magick::CenterGravity, -500, 350, Magick::CopyOpacityCompositeOp)
      append_image2 = append_image.composite(gone_mask, Magick::CenterGravity, -720, 750, Magick::CopyOpacityCompositeOp)
      append_image3 = append_image.composite(gone_mask, Magick::CenterGravity, -250, 750, Magick::CopyOpacityCompositeOp)
      result = gone.composite(append_image1, Magick::CenterGravity, 500, -350, Magick::OverCompositeOp)
      result.composite!(append_image2, Magick::CenterGravity, 720, -750, Magick::OverCompositeOp)
      result.composite!(append_image3, Magick::CenterGravity, 250, -750, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      append_image1.destroy!
      append_image2.destroy!
      append_image3.destroy!
      result.destroy!

      nil
    end
  end
end
