module Discordrb::Webhooks
  class Embed
    # https://github.com/meew0/discordrb/blob/6870129ad5b308838318d0ff3780d871acab6934/lib/discordrb/webhooks/embeds.rb
    # https://github.com/meew0/discordrb/blob/048c1fe22f95ee62141182108a9b447d7204d5b1/lib/discordrb/data.rb#L1543
    # Only adds the final else statement, so that if there is not a color, a default color is applied.
    def colour=(value)
      if value.is_a? Integer
        raise ArgumentError, 'Embed colour must be 24-bit!' if value >= 16_777_216
        @colour = value
      elsif value.is_a? String
        self.colour = value.delete('#').to_i(16)
      elsif value.is_a? Array
        raise ArgumentError, 'Colour tuple must have three values!' if value.length != 3
        self.colour = value[0] << 16 | value[1] << 8 | value[2]
      else
        @colour = Bot.normalcolor
      end
    end
  end
end
