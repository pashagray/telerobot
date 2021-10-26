# frozen_string_literal: true

module Telerobot
  module Types
    class Chat < Base
      attribute :id, Integer
      attribute :type, String
      attribute :title, String
      attribute :username, String
      attribute :first_name, String
      attribute :last_name, String

      def initialize(attributes = {})
        super(attributes)
        @command = nil
        @keyboard = NoKeyboardMarkup.new
        @api = nil
      end

      def attach_api(api)
        @api = api
        self
      end

      def add_message(text, options = {})
        @command = Commands::SendMessage.new(text, options)
        self
      end

      def add_photo(photo, options = {})
        @command = Commands::SendPhoto.new(photo, options)
        self
      end

      def add_keyboard(keyboard, options = {})
        @keyboard = ReplyKeyboardMarkup.new(keyboard, options)
        self
      end

      def send_now
        raise 'API is not attached' unless @api

        @api.request!(command: @command, chat_id: @id, keyboard: @keyboard)
      end
    end
  end
end