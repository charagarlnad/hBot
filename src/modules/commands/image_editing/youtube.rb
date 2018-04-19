module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:youtube, type: :'Image Editing') do |event|
      canvas = Magick::Image.read('data/command_data/youtube/source.png').first
      mask = Magick::Image.read('data/command_data/youtube/mask.png').first.negate
      mask.matte = false

      append_image = Magick::Image.from_blob(event.image_source).first.scale(600, 400)

      append_image.composite!(mask, Magick::CenterGravity, 600, 20, Magick::CopyOpacityCompositeOp)
      canvas.composite!(append_image, Magick::CenterGravity, -600, -20, Magick::OverCompositeOp)

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
