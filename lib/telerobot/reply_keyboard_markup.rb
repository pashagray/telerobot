# frozen_string_literal: true

module Telerobot
  # https://core.telegram.org/bots/api#replykeyboardmarkup
  class ReplyKeyboardMarkup
    def initialize(keyboard, options = {})
      @keyboard = keyboard
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
