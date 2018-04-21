module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:proto, type: :'Image Editing') do |event|
      # reading from memory is slower
      canvas = Magick::Image.read('data/command_data/proto/proto.png').first
      mask = Magick::Image.read('data/command_data/proto/mask.png').first.negate
      mask.matte = false

      # possibly make below use actual size of image and not scale to 350, 350 using a array of the x and y size and .min and .max it
      append_image = Magick::Image.from_blob(event.image_source).first.scale(350, 350)

      append_image.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
      canvas.composite!(append_image, Magick::CenterGravity, 0, -200, Magick::OverCompositeOp)

      upload = Tempfile.new(['hBot', '.png']) # the array here forces the tempfile to put the file extension at the end of the file
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
