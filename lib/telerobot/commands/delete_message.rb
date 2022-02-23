# frozen_string_literal: true

module Telerobot
  module Commands
    class DeleteMessage
      METHOD = "deleteMessage"

      def initialize(options = {})
        @message_id = options.fetch(:message_id, false)
      end

      def body
        [
          ["message_id", @message_id]
        ]
      end

      def method
        METHOD
      end
    end
  end
end
