# frozen_string_literal: true

module Telerobot
  # https://core.telegram.org/bots/api#replykeyboardmarkup
  class ReplyKeyboardMarkup
    def initialize(buttons, options = {})
      @keyboard = buttons.map do |row|
        row.map do |button|
          if button.is_a?(String)
            KeyboardButton.new(text: button).markup
          else
            KeyboardButton.new(**button).markup
          end
        end
      end
      @one_time_keyboard = options.fetch(:one_time, false)
      @resize_keyboard = options.fetch(:resize, false)
    end

    def markup
      {
        keyboard: @keyboard,
        one_time_keyboard: @one_time_keyboard,
        resize_keyboard: @resize_keyboard
      }
    end
  end
end
