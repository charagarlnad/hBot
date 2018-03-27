module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :porn do |event|
      canvas = Magick::Image.read('data/command_data/porn/source.png').first
      mask = Magick::Image.read('data/command_data/porn/mask.png').first.negate
      mask.matte = false

      append_image = Magick::Image.from_blob(event.get_editimage).first.scale(846, 478)

      append_image.composite!(mask, Magick::CenterGravity, -45, -120, Magick::CopyOpacityCompositeOp)
      canvas.composite!(append_image, Magick::CenterGravity, 45, 120, Magick::OverCompositeOp)

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
