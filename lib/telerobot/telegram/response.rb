# frozen_string_literal: true

module Telerobot
  module Telegram
    class Response
      attr_reader :body, :code, :error

      def initialize(response)
        @body = JSON.parse(response.body, symbolize_names: true)
        @success = response.is_a?(Net::HTTPSuccess)
        @code = @body[:error_code] || 200
        @error = @body[:description]
      end

      def success?
        @success
      end
    end
  end
end
