module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    mariodelet = Magick::Image.read('data/command_data/mariodelet/source.png').first
    command(:mariodelet, type: :'Image Editing') do |event|
      canvas = Magick::Image.from_blob(event.image_source).first

      background = Magick::Image.new(canvas.columns * 1.68, canvas.rows) do |c|
        c.format = 'png'
        c.background_color = 'Transparent'
      end

      background.composite!(canvas, Magick::SouthWestGravity, 0, 0, Magick::OverCompositeOp)
      background.composite!(mariodelet.scale(canvas.columns * 0.8, canvas.columns), Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(background.to_blob, "#{event.message.id}.png")

      canvas.destroy!
      background.destroy!

      nil
    end
  end
end
