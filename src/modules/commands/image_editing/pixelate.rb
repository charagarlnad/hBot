module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:pixelate, type: :'Image Editing') do |event|
      canvas = Magick::Image.from_blob(event.image_source).first.scale(16, 16).scale(1024, 1024)

      event.channel.send_file BinaryImage.new(canvas.to_blob, "#{event.message.id}.png")

      canvas.destroy!

      nil
    end
  end
end
