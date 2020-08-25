# frozen_string_literal: true

require_relative "./methods/send_message"
require_relative "./methods/send_photo"

module Telerobot
  module Telegram
    module Api
      def send_now
        reply_markup = define_keyboard(@keyboard, @one_time_keyboard, @inline_keyboard)

        return Telegram::Methods::SendMessage.perform(@chat_id, @token, @message, reply_markup) unless @photos

        return Telegram::Methods::SendPhoto.perform(@chat_id, @token, @message, @photos.first, reply_markup) if @photos.size == 1
      end

      def define_keyboard(keyboard, one_time_keyboard, inline_keyboard)
        return unless keyboard || inline_keyboard

        markup = {}

        if keyboard
          markup[:keyboard] = keyboard
          markup[:one_time_keyboard] = one_time_keyboard
        end

        if inline_keyboard
          markup[:inline_keyboard] = inline_keyboard
        end
        markup
      end

      private :define_keyboard
    end
  end
end
