# frozen_string_literal: true

module Telerobot
  class SendMessage
    METHOD = "sendMessage"

    def initialize(text, options = {})
      @text = text
      @parse_mode = "MarkdownV2"
      @disable_web_page_preview = options.fetch(:disable_web_page_preview, false)
      @disable_notification = options.fetch(:disable_notification, false)
    end

    def body
      [
        ["text", @text],
        ["parse_mode", @parse_mode],
        ["disable_web_page_preview", @disable_web_page_preview.to_s],
        ["disable_notification", @disable_notification.to_s]
      ]
    end

    def method
      METHOD
    end
  end
end
