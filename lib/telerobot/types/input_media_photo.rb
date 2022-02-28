# frozen_string_literal: true

module Telerobot
  module Types
    class InputMediaPhoto < Base
      attribute :media, String
      attribute :caption, String

      def markup
        {
          type: "photo",
          media: "attach://#{attachment_name}",
          caption: @caption,
          parse_mode: "MarkdownV2"
        }
      end

      def attachment_name
        @media_attach_name ||= SecureRandom.hex(10)
      end

      def attachment
        @media
      end
    end
  end
end
