module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:crash, type: :'Image Editing') do |event|
      # Use pitch/skew to make this look better
      canvas = Magick::Image.read('data/command_data/crash/source.png').first
      mask = Magick::Image.read('data/command_data/crash/mask.png').first.negate
      mask.matte = false

      append_image = Magick::Image.from_blob(event.image_source).first.scale(500, 400)

      append_image.composite!(mask, Magick::CenterGravity, 220, -40, Magick::CopyOpacityCompositeOp)
      canvas.composite!(append_image, Magick::CenterGravity, -220, 40, Magick::OverCompositeOp)

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
