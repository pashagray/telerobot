require "net/http"
require "json"

require_relative "./telegram/api"

module Telerobot
  class Chat
    include Telerobot::Telegram::Api

    def initialize(chat_id:, token:)
      @chat_id = chat_id
      @token = token
      @message = nil
      @photos = nil
      @keyboard = nil
      @inline_keyboard = nil
    end

    def message(message)
      @message = message
      self
    end

    def keyboard(keyboard, onetime: false)
      @keyboard = keyboard
      @one_time_keyboard = onetime
      self
    end

    def inline_keyboard(keyboard)
      @inline_keyboard = keyboard
      self
    end

    def photos(photos)
      @photos = photos
      self
    end

    def photo(photo)
      photos([photo])
      self
    end
  end
end
