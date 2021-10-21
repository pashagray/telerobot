# frozen_string_literal: true

module Telerobot
  class Chat
    def initialize(chat_id:, token:)
      @api = Telegram::Api.new(chat_id, token)
      @message = nil
      @photos = nil
      @keyboard = nil
      @inline_keyboard = nil
    end

    def message(message)
      @message = message
      self
    end

    def photo(photo)
      photos([photo])
      self
    end

    def photos(photos)
      @photos = photos
      self
    end

    def keyboard(keyboard, onetime: false, resize: true)
      @keyboard = keyboard
      @one_time_keyboard = onetime
      @resize_keyboard = resize
      self
    end

    def inline_keyboard(keyboard)
      @inline_keyboard = keyboard
      self
    end

    def send_now
      return @api.send_message(@message, reply_markup) unless @photos

      @api.send_photo(@message, *@photos, reply_markup) if @photos.size == 1
    end

    def reply_markup
      reply_markup = {}
      return reply_markup unless @keyboard && @inline_keyboard

      if @keyboard
        reply_markup[:reply_markup] = {
          keyboard: keyboard,
          resize_keyboard: true,
          one_time_keyboard: @one_time_keyboard
        }
      end

      if @inline_keyboard
        reply_markup[:reply_markup] = {
          inline_keyboard: @inline_keyboard
        }
      end
    end
  end
end
