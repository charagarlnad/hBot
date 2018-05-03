module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:magick, type: :'Image Editing', description: 'Apply Magik to a [**image**].') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first

      # https://rmagick.github.io/image2.html#liquid_rescale
      append_image = append_image.liquid_rescale(append_image.columns * 0.5, append_image.rows * 0.5, 1)
      append_image = append_image.liquid_rescale(append_image.columns * 1.5, append_image.rows * 1.5, 2)

      event.channel.send_file BinaryImage.new(append_image.to_blob, "#{event.message.id}.png")

      append_image.destroy!

      nil
    end
  end
end
