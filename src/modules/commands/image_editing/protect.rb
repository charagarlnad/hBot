module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:protect, type: :'Image Editing') do |event|
      canvas = Magick::Image.read('data/command_data/protect/source.png').first

      append_image = Magick::Image.from_blob(event.image_source).first.resize_to_fit(350, 250)

      canvas.composite!(append_image, Magick::CenterGravity, 0, -115, Magick::OverCompositeOp)

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
