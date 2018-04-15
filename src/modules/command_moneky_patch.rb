module Discordrb::Commands
  class Command
    def initialize(name, attributes = {}, &block)
      @name = name
      @attributes = {
        # The lowest permission level that can use the command
        permission_level: attributes[:permission_level] || 0,

        # Message to display when a user does not have sufficient permissions to execute a command
        permission_message: attributes[:permission_message].is_a?(FalseClass) ? nil : (attributes[:permission_message] || "You don't have permission to execute command %name%!"),

        # Discord action permissions required to use this command
        required_permissions: attributes[:required_permissions] || [],

        # Roles required to use this command
        required_roles: attributes[:required_roles] || [],

        # Channels this command can be used on
        channels: attributes[:channels] || nil,

        # Whether this command is usable in a command chain
        chain_usable: attributes[:chain_usable].nil? ? true : attributes[:chain_usable],

        # Whether this command should show up in the help command
        help_available: attributes[:help_available].nil? ? true : attributes[:help_available],

        # Description (for help command)
        description: attributes[:description] || nil,

        # Usage description (for help command and error messages)
        usage: attributes[:usage] || nil,

        # Array of arguments (for type-checking)
        arg_types: attributes[:arg_types] || nil,

        # Parameter list (for help command and error messages)
        parameters: attributes[:parameters] || nil,

        # Minimum number of arguments
        min_args: attributes[:min_args] || 0,

        # Maximum number of arguments (-1 for no limit)
        max_args: attributes[:max_args] || -1,

        # Message to display upon rate limiting (%time% in the message for the remaining time until the next possible
        # request, nil for no message)
        rate_limit_message: attributes[:rate_limit_message],

        # Rate limiting bucket (nil for no rate limiting)
        bucket: attributes[:bucket],

        # Block for handling internal exceptions, or a string to respond with
        rescue: attributes[:rescue],

        ### start additon
        requirements: attributes[:requirements] || [],
        type: attributes[:type] || :Unsorted
        ### end additon

      }

      @block = block
    end
    # https://github.com/meew0/discordrb/blob/master/lib/discordrb/commands/parser.rb#L76
    def call(event, arguments, chained = false, check_permissions = true)
      if arguments.length < @attributes[:min_args]
        event.respond "Too few arguments for command `#{name}`!"
        event.respond "Usage: `#{@attributes[:usage]}`" if @attributes[:usage]
        return
      end
      if @attributes[:max_args] >= 0 && arguments.length > @attributes[:max_args]
        event.respond "Too many arguments for command `#{name}`!"
        event.respond "Usage: `#{@attributes[:usage]}`" if @attributes[:usage]
        return
      end
      ### begin additon
      @attributes[:requirements].each do |arg|
        error = case arg
                when :in_voice then 'I am not in voice.' if event.voice.nil?
                when :playing then 'There is nothing playing.' unless event.voice.playing?
                when :queue_not_empty then 'There is nothing in the queue.' if $masterqueue[event.server.id].empty?
                when :has_arguments_or_attachment then 'A search or attachment is required.' if event.content.split(' ').size == 1 && event.message.attachments.empty?
                when :has_arguments then 'A search is required.' if event.content.split(' ').size == 1 
                when :arguments_is_int then 'That is not a number.' unless event.content.split(' ')[1].is_i?
                else nil
                end
        if error
          event.send_timed_embed do |e|
            e.description = error
            e.color = 0x7289DA
          end
          return nil

        end
      end
      ### end additon
      unless @attributes[:chain_usable]
        if chained
          event.respond "Command `#{name}` cannot be used in a command chain!"
          return
        end
      end

      if check_permissions
        rate_limited = event.bot.rate_limited?(@attributes[:bucket], event.author)
        if @attributes[:bucket] && rate_limited
          if @attributes[:rate_limit_message]
            event.respond @attributes[:rate_limit_message].gsub('%time%', rate_limited.round(2).to_s)
          end
          return
        end
      end

      result = @block.call(event, *arguments)
      event.drain_into(result)
    rescue LocalJumpError => ex # occurs when breaking
      result = ex.exit_value
      event.drain_into(result)
    rescue => exception # Something went wrong inside our @block!
      rescue_value = @attributes[:rescue] || event.bot.attributes[:rescue]
      if rescue_value
        event.respond(rescue_value.gsub('%exception%', exception.message)) if rescue_value.is_a?(String)
        rescue_value.call(event, exception) if rescue_value.respond_to?(:call)
      end

      raise exception
    end

  end
end