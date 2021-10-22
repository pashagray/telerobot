# frozen_string_literal: true

module Telerobot
  module Commands
    class SendPhoto
      METHOD = "sendPhoto"

      def initialize(photo_path, options = {})
        @photo = File.open(photo_path)
        @parse_mode = "MarkdownV2"
        @caption = options.fetch(:caption, nil)
        @disable_notification = options.fetch(:disable_notification, false)
      end

      def schema
        [
          ["photo", @photo],
          ["caption", @caption],
          ["parse_mode", @parse_mode],
          ["disable_web_page_preview", @disable_web_page_preview.to_s],
          ["disable_notification", @disable_notification.to_s]
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
