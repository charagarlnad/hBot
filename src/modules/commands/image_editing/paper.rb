module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:paper, type: :'Image Editing') do |event|
      canvas = Magick::Image.read('data/command_data/paper/source.png').first

      append_image = Magick::Image.from_blob(event.image_source).first.resize_to_fit(444, 486)

      canvas.composite!(append_image, Magick::CenterGravity, 15, 0, Magick::OverCompositeOp)

      upload = Tempfile.new(['hBot', '.png'])
      canvas.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!
      append_image.destroy!

      nil
    end
  end
end
