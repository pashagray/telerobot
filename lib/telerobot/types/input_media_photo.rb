# frozen_string_literal: true

module Telerobot
  module Types
    class InputMediaPhoto < Base
      attribute :media, String
      attribute :caption, String

      def markup
        {
          type: "photo",
          media: @media,
          caption: @caption,
          parse_mode: "MarkdownV2"
        }
      end
    end
  end
end
