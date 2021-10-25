# frozen_string_literal: true

module Telerobot
  module Types
    class Message < Base
      attribute :message_id, Integer
      attribute :date, Integer
      attribute :text, String
      attribute :contact, Contact
      attribute :location, Location
      attribute :photo, array_of(PhotoSize)
    end
  end
end
