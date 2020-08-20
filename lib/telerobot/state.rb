module Telerobot
  module State
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      #
      # Map commands from telegram to State methods
      #
      # command_mapping({
      # /-regexp-match-/   => foo
      # /-string-include-/ => bar
      # })
      #
      def command_mapping(mapping)
        @mapping = mapping
      end

      def mapping
        @mapping || {}
      end
    end

    def call(message, callback_query, session)
      @message = message.transform_keys(&:to_sym)
      @callback_query = callback_query.transform_keys(&:to_sym)
      @session = session
      option = nil
      @command = (callback_query && callback_query[:data]) || message[:text]
      if message[:contact]
        on_contact_receive(message[:contact])
      else
        self.class.mapping.keys.select { |key| key.class == String }.each do |map_key|
          option ||= map_key if @command == map_key
        end
        self.class.mapping.keys.select { |key| key.class == Regexp }.each do |map_key|
          option ||= map_key if @command.match(map_key)
        end
        if option
          invoke_command_method(option)
        else
          unknown_command
        end
      end
    end

    def invoke_command_method(command)
      method = self.class.mapping[command]
      if respond_to?(method)
        send(method)
      else
        command_method_not_found
      end
    end

    # Move to new State
    def move_to(new_state)
      before_exit
      new_state.new.enter(@session)
    end

    def enter(session)
      @session = session
      before_enter
      @session.update(state: self.class.to_s)
      after_enter
    end

    def current_chat
      Chat.new(@session.chat_id)
    end

    def on_contact_receive
      unknown_command
    end

    def session
      @session
    end

    def message
      @message || {}
    end

    def callback_query
      @callback_query || {}
    end

    def unknown_command
      raise Error,
        <<~HEREDOC
          Unknown command +#{@command}+

          Add it command_mapping:
          command_mapping({
            "#{@command}" => :your_method_to_be_ivoked
          })

          Also you can override unkown_command method to handle
          such errors. Example:

          def unknown_command
            # your_logic
          end
        HEREDOC
    end

    def command_method_not_found
      raise Error,
        <<~HEREDOC
          Command +#{@command}+ found, but correspoing method does not exist

          Add method to your state:
          def #{self.class.mapping[@command]}
            # your logic
          end
        HEREDOC
    end

    # Callbacks

    # Callback invoked when exiting State
    def before_exit
      # Override to add your own logic
    end

    # Callback invoked when entering State, before changing session state
    def before_enter
      # Override to add your own logic
    end

    # Callback invoked when entering State, after changing session state
    def after_enter
      # Override to add your own logic
    end
  end
end