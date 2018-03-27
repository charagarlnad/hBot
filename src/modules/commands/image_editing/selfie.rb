module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :selfie do |event|
      canvas = Magick::Image.from_blob(event.get_editimage).first
      append_image = Magick::Image.read('data/command_data/selfie/selfie.png').first.scale(canvas.columns, canvas.columns * 0.586)

      canvas.composite!(append_image, Magick::SouthWestGravity, 0, 0, Magick::OverCompositeOp)

      upload = Tempfile.new(['imgbot', '.png'])
      canvas.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!
      append_image.destroy!

      nil
    end
  end
end
