module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:gone, type: :'Image Editing') do |event|
      #maybe optimize by making 1 append image with 3 insside of it on 1 level and move them to the correct spots
      canvas = Magick::Image.read('data/command_data/gone/source.png').first
      mask = Magick::Image.read('data/command_data/gone/mask.png').first.negate
      mask.matte = false

      append_image = Magick::Image.from_blob(event.get_editimage).first.scale(410, 410)
      append_image2 = Magick::Image.from_blob(event.get_editimage).first.scale(410, 410)
      append_image3 = Magick::Image.from_blob(event.get_editimage).first.scale(410, 410)

      append_image.composite!(mask, Magick::CenterGravity, -500, 350, Magick::CopyOpacityCompositeOp)
      append_image2.composite!(mask, Magick::CenterGravity, -720, 750, Magick::CopyOpacityCompositeOp)
      append_image3.composite!(mask, Magick::CenterGravity, -250, 750, Magick::CopyOpacityCompositeOp)
      canvas.composite!(append_image, Magick::CenterGravity, 500, -350, Magick::OverCompositeOp)
      canvas.composite!(append_image2, Magick::CenterGravity, 720, -750, Magick::OverCompositeOp)
      canvas.composite!(append_image3, Magick::CenterGravity, 250, -750, Magick::OverCompositeOp)

      upload = Tempfile.new(['imgbot', '.png'])
      canvas.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!
      mask.destroy!
      append_image.destroy!

      nil
    end
  end
end
