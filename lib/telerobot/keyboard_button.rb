# frozen_string_literal: true

module Telerobot
  class KeyboardButton
    def initialize(text:, request_contact: false, request_location: false)
      @text = text
      @request_contact = request_contact
      @request_location = request_location
    end

    def markup
      {
        text: @text,
        request_contact: @request_contact,
        request_location: @request_location
      }
    end
  end
end
