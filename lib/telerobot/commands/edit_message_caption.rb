# frozen_string_literal: true

module Telerobot
  module Commands
    class EditMessageCaption
      METHOD = "editMessageCaption"

      def initialize(caption, options = {})
        @caption = caption
        @parse_mode = "MarkdownV2"
        @message_id = options.fetch(:message_id, false)
      end

      def body
        [
          ["caption", @caption],
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
