# frozen_string_literal: true

module Telerobot
  module Commands
    class EditMessageMedia
      METHOD = "editMessageMedia"

      def initialize(media, options = {})
        @media = media
        @message_id = options.fetch(:message_id)
      end

      def schema
        [
          ["media", @media.markup.to_json],
          ["message_id", @message_id],
          [@media.attachment_name, @media.attachment]
        ]
      end

      def body
        schema.map do |key, val|
          [key, val] unless val.nil?
        end.compact
      end

      def method
        METHOD
      end
    end
  end
end
