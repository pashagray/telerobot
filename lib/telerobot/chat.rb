# frozen_string_literal: true

module Telerobot
  class Chat
    def initialize(chat_id:, token:)
      @api = Telegram::Api.new(chat_id, token)
      @message = nil
      @photos = nil
      @keyboard = NoKeyboardMarkup.new
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

    def keyboard(keyboard, options = {})
      @keyboard = ReplyKeyboardMarkup.new(keyboard, options)
      self
    end

    def send_now
      return @api.send_message(@message, @keyboard) unless @photos

      @api.send_photo(@message, @photos, @keyboard) if @photos.size == 1
    end
  end
end
