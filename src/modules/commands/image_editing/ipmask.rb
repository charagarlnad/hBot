module Bot::DiscordCommands
  module ImageEditing
    extend Discordrb::Commands::CommandContainer
    command(:ipmask, type: :'Image Editing') do |event|
      upload = Tempfile.new(['imgbot', '.png'])
      IO.copy_stream(StringIO.new(event.get_editimage), upload.path)

      detector = OpenCV::CvHaarClassifierCascade::load('data/command_data/ipmask/haarcascade_frontalface_alt.xml')
      image = OpenCV::CvMat.load(upload.path)

      canvas = Magick::Image.read(upload.path).first
      append_image = Magick::Image.read('data/command_data/ipmask/mask.png').first

      detector.detect_objects(image).each do |region|
        append_image = Magick::Image.read('data/command_data/ipmask/mask.png').first.scale!(region.height, region.width)
        canvas.composite!(append_image.scale(region.height, region.width), Magick::NorthWestGravity, region.x, region.y, Magick::OverCompositeOp)
      end

      canvas.write(upload.path)
      event.channel.send_file upload

      upload.close!
      canvas.destroy!

      nil
    end
  end
end
