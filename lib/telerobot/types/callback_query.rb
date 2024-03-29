# frozen_string_literal: true

module Telerobot
  module Types
    class CallbackQuery < Base
      attribute :id, String
      attribute :from, User
      attribute :message, Types::Message
      attribute :inline_message_id, String
      attribute :chat_instance, String
      attribute :data, String
      attribute :game_short_name, String
    end
  end
end
