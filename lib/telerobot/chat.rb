# frozen_string_literal: true

module Telerobot
  class Chat
    def initialize(api)
      @api = api
      @command = nil
      @photos = nil
      @keyboard = NoKeyboardMarkup.new
    end

    def message(text, options = {})
      @command = SendMessage.new(text, options)
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
      @api.request!(@command, @keyboard)
    end
  end
end
