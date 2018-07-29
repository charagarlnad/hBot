module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    paper = Magick::Image.read('data/command_data/paper/source.png').first
    command(:paper, type: :'Image Editing') do |event|
      append_image = Magick::Image.from_blob(event.image_source).first.resize_to_fit(444, 486)

      result = paper.composite(append_image, Magick::CenterGravity, 15, 0, Magick::OverCompositeOp)

      event.channel.send_file BinaryImage.new(result.to_blob, "#{event.message.id}.png")

      append_image.destroy!
      result.destroy!

      nil
    end
  end
end
