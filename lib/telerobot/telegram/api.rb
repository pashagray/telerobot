# frozen_string_literal: true

require_relative "./methods/send_message"
require_relative "./methods/send_photo"

module Telerobot
  module Telegram
    module Api
      def send_now
        case [@message, @photos]
        in [String, nil]
          Telegram::Methods::SendMessage.perform(
            @chat_id, @token,
            @message, @keyboard, @one_time_keyboard,
            @inline_keyboard
          )
        in [String, [element]]
          Telegram::Methods::SendPhoto.perform(
            @chat_id, @token, @message,
            @photos, @keyboard, @one_time_keyboard,
            @inline_keyboard
          )
        in [String, [*elements]]
          Telegram::Methods::SendMediaGroup.perform(
            @chat_id, @token, @message,
            @photos, @keyboard, @one_time_keyboard,
            @inline_keyboard
          )
        end
      end

      def send_later
        # TODO
      end
    end
  end
end
