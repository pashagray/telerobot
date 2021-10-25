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
        parent_class_mapping.merge(@mapping || {})
      end

      def parent_class_mapping
        superclass.respond_to?(:mapping) ? superclass.mapping : {}
      end

      def configure
        yield set_config
      end

      def set_config
        @config = Config.new
      end

      def config
        @config ||= parent_class_config
      end

      def parent_class_config
        superclass.respond_to?(:config) ? superclass.config : Config.new
      end
    end

    def call(message, callback_query, session)
      telegram_bot_token_missing unless config.bot_token

      @message = Utils.deep_symbolize_keys(message)
      @callback_query = Utils.deep_symbolize_keys(callback_query)
      @session = session
      option = nil
      @command = (callback_query && callback_query[:data]) || message[:text]
      if message[:contact]
        handle_contact_message(message[:contact])
      elsif message[:location]
        handle_location_message(message[:location])
      elsif message[:photo]
        handle_photo_message(message[:photo])
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
      Chat.new(Api.new(session.chat_id, config.bot_token))
    end

    def handle_contact_message(contact_data)
      contact = Types::Contact.new(**Utils.deep_symbolize_keys(contact_data))
      on_contact_receive(contact)
    end

    def handle_location_message(location_data)
      location = Types::Location.new(**Utils.deep_symbolize_keys(location_data))
      on_location_receive(location)
    end

    def handle_photo_message(photo_variants)
      sorted_photos = photo_variants
        .map { |photo| Utils.deep_symbolize_keys(photo) }
        .sort_by { |photo| -photo[:file_size] }

      on_photo_receive(*sorted_photos)
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

    def config
      self.class.config
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

    def telegram_bot_token_missing
      raise Error,
        <<~HEREDOC
          Bot token must be provided.
          You should configure your class with telegram bot token
          Add to your #{self.class.name} class configure class method
          Example:
            class #{self.class.name}
              include Telerobot::State

              configure do |config|
                config.bot_token = "token"
              end
            end
        HEREDOC
    end

    # Callbacks

    def on_photo_receive(original, medium, small)
      raise Error,
        <<~HEREDOC
          Photo detected. Add logic to handle it.

          Add photo receiving logic. All photos has similar file_id,
          but different file_unique_id. Also you can access width, height
          and file_size.

          def on_photo_receive(photo)
            # your_logic
          end

          -- Photo variants --

          original:
            file_id: #{original[:file_id]}
            file_unique_id: #{original[:file_unique_id]}
            width: #{original[:width]}
            height: #{original[:height]}
            file_size: #{original[:file_size]}

          medium:
            file_id: #{medium[:file_id]}
            file_unique_id: #{medium[:file_unique_id]}
            width: #{medium[:width]}
            height: #{medium[:height]}
            file_size: #{medium[:file_size]}

          small:
            file_id: #{small[:file_id]}
            file_unique_id: #{small[:file_unique_id]}
            width: #{small[:width]}
            height: #{small[:height]}
            file_size: #{small[:file_size]}
        HEREDOC
    end

    def on_contact_receive(contact)
      raise Error,
        <<~HEREDOC
          User sent contacts. Add logic to handle it.

          def on_contact_receive(contact)
            # your_logic
          end

          -- Contact type --

          phone_number: #{contact.phone_number}
          first_name: #{contact.first_name}
          last_name: #{contact.last_name}
          user_id: #{contact.user_id}
        HEREDOC
    end

    def on_location_receive(location)
      raise Error,
        <<~HEREDOC
          User sent location. Add logic to handle it.

          def on_location_receive(location)
            # your_logic
          end

          -- Location type --

          longitude: #{location.longitude}
          latitude: #{location.latitude}
          horizontal_accuracy: #{location.horizontal_accuracy}
          live_period: #{location.live_period}
          heading: #{location.heading}
          proximity_alert_radius: #{location.proximity_alert_radius}
        HEREDOC
    end

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
