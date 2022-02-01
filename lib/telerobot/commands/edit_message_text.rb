# frozen_string_literal: true

module Telerobot
  module Commands
    class EditMessageText
      METHOD = "editMessageText"

      def initialize(text, options = {})
        @text = text
        @parse_mode = "MarkdownV2"
        @message_id = options.fetch(:message_id, false)
      end

      def body
        [
          ["text", @text],
          ["parse_mode", @parse_mode],
          ["message_id", @message_id]
        ]
      end

      def method
        METHOD
      end
    end
  end
end
