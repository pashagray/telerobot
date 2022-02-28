# frozen_string_literal: true

module Telerobot
  module Types
    class InputMediaPhoto < Base
      attribute :media, String
      attribute :caption, String

      def schema
        [
          ["type", "photo"],
          ["media", @media],
          ["caption", @caption],
          ["parse_mode", "MarkdownV2"]
        ]
      end

      def body
        schema.map do |key, val|
          [key, val] unless val.nil?
        end.compact
      end
    end
  end
end
