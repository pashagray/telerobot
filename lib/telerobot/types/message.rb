# frozen_string_literal: true

module Telerobot
  module Types
    # https://core.telegram.org/bots/api#message
    class Message < Base
      attribute :message_id, Integer
      attribute :date, Integer
      attribute :chat, Chat
      attribute :text, String
      attribute :caption, String
      attribute :contact, Contact
      attribute :location, Location
      attribute :photo, array_of(PhotoSize)
    end
  end
end
