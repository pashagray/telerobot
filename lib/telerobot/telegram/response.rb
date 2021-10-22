# frozen_string_literal: true

module Telerobot
  module Telegram
    class Response
      attr_reader :body, :code, :error

      def initialize(body)
        @body = body
        @success = body[:ok] || false
        @code = body[:error_code] || 200
        @error = body[:description]
      end

      def success?
        @success
      end
    end
  end
end
