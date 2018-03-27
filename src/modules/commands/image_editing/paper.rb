module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command :paper do |event|
      canvas = Magick::Image.read('data/command_data/paper/source.png').first

      append_image = Magick::Image.from_blob(event.get_editimage).first.resize_to_fit(444, 486)

      canvas.composite!(append_image, Magick::CenterGravity, 15, 0, Magick::OverCompositeOp)

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
