# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendMessage
        class << self
          def perform(chat_id, token, message, reply_markup)
            uri = URI("https://api.telegram.org/bot#{token}/sendMessage")
            body = reply_markup ? { chat_id: chat_id, text: message, parse_mode: "Markdown", reply_markup: reply_markup } : { chat_id: chat_id, text: message, parse_mode: "Markdown" }
            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              post = Net::HTTP::Post.new(uri)
              post.content_type = "application/json"
              post.body = body.to_json
              http.request(post)
            end
          end
        end
      end
    end
  end
end
