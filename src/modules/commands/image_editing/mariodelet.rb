module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:mariodelet, type: :'Image Editing') do |event|
      canvas = Magick::Image.from_blob(event.image_source).first

      background = Magick::Image.new(canvas.columns * 1.68, canvas.rows) do |c|
        c.background_color = 'Transparent'
      end

      append_image = Magick::Image.read('data/command_data/mariodelet/source.png').first.scale(canvas.columns * 0.8, canvas.columns)

      background.composite!(canvas, Magick::SouthWestGravity, 0, 0, Magick::OverCompositeOp)
      background.composite!(append_image, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)

      upload = Tempfile.new(['imgbot', '.png'])
      background.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!
      append_image.destroy!
      background.destroy!

      nil
    end
  end
end
