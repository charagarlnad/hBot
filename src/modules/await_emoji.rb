module Discordrb::Events
  # Generic superclass for events about adding and removing reactions
  class ReactionEvent < Event
    # https://github.com/meew0/discordrb/commit/445d9a51cf844cc76a2ce02ab3bd9ef8e3ff8653#diff-974b556cee7010d55a760589d63a82c8
    def server
      
    end
  end


  class ReactionEventHandler < EventHandler
    def matches?(event)
      # Check for the proper event type
      # https://github.com/meew0/discordrb/blob/15c969b30e1b5e6f69e704003af72268f36c90d7/lib/discordrb/events/reactions.rb#L50
      # monkey patches in :from and :message lmao
      return false unless event.is_a? ReactionEvent

      [
        matches_all(@attributes[:emoji], event.emoji) do |a, e|
          if a.is_a? Integer
            e.id == a
          elsif a.is_a? String
            e.name == a || e.name == a.delete(':') || e.id == a.resolve_id
          else
            e == a
          end
        end,
        matches_all(@attributes[:from], event.user) do |a, e|
          if a.is_a? String
            a == e.name
          elsif a.is_a? Integer
            a == e.id
          elsif a == :bot
            e.current_bot?
          else
            a == e
          end
        end,
        matches_all(@attributes[:message], event.message) do |a, e|
          if a.is_a? Integer
            a == e.id
          else
            a == e
          end
        end
      ].reduce(true, &:&)
    end
  end

end