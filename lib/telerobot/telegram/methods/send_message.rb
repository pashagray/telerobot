# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendMessage
        class << self
          def perform(chat_id, token, text, reply_markup)
            uri = URI("https://api.telegram.org/bot#{token}/sendMessage")
            query = { chat_id: chat_id, text: text }.merge(reply_markup)

            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              req["Content-Type"] = "application/json"
              req = Net::HTTP::Post.new(uri)
              req.body = query.to_json
              http.request(req)
            end
          end
        end
      end
    end
  end
end
