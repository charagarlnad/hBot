module Discordrb::Events
  module Respondable
    def send_timed_embed(message = '', embed = nil, &block)
      Thread.new do
        emb = channel.send_embed(message, embed, &block)
        sleep(30)
        emb.delete
      end
      nil
    end
  end
end
