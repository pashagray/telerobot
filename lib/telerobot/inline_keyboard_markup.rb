# frozen_string_literal: true

module Telerobot
  # https://core.telegram.org/bots/api#inlinekeyboardmarkup
  class InlineKeyboardMarkup
    def initialize(buttons)
      @keyboard = buttons.map do |row|
        row.map do |button|
          if button.is_a?(String)
            InlineKeyboardButton.new(text: button).markup
          else
            InlineKeyboardButton.new(**button).markup
          end
        end
      end
    end

    def markup
      {
        inline_keyboard: @keyboard
      }
    end
  end
end
