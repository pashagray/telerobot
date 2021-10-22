# frozen_string_literal: true

module Telerobot
  module Telegram
    class Api
      def initialize(chat_id, token)
        @chat_id = chat_id
        @token = token
      end

      def send_message(text, keyboard = NoKeyboardMarkup.new)
        Telegram::Methods::SendMessage.perform(@chat_id, @token, text, keyboard.markup)
      end

      def send_photo(text, photo, keyboard = NoKeyboardMarkup)
        Telegram::Methods::SendPhoto.perform(@chat_id, @token, text, photo, keyboard.markup)
      end
    end
  end
end
