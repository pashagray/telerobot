# frozen_string_literal: true

require_relative "./methods/send_message"
require_relative "./methods/send_photo"

module Telerobot
  module Telegram
    class Api
      def initialize(chat_id, token)
        @chat_id = chat_id
        @token = token
      end

      def send_message(text, reply_markup)
        Telegram::Methods::SendMessage.perform(@chat_id, @token, text, reply_markup)
      end

      def send_photo(text, photo, reply_markup)
        Telegram::Methods::SendPhoto.perform(@chat_id, @token, text, photo, reply_markup)
      end
    end
  end
end
