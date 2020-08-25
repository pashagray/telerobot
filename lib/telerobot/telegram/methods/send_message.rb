# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendMessage
        class << self
          def perform(chat_id, token, message, keyboard, one_time_keyboard, inline_keyboard)
            uri = URI("https://api.telegram.org/bot#{token}/SendMessage")
            query = build_query(chat_id, message, keyboard, one_time_keyboard, inline_keyboard)
            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              req = Net::HTTP::Post.new(uri)
              req["Content-Type"] = "application/json"
              req.body = query.to_json
              http.request(req)
            end
          end

          private

          def build_query(chat_id, message, keyboard, one_time_keyboard, inline_keyboard)
            query = { chat_id: chat_id }
            query[:text] = message if message
            if keyboard
              query[:reply_markup] = {
                keyboard: keyboard,
                one_time_keyboard: one_time_keyboard
              }
            end

            if inline_keyboard
              query[:reply_markup] = {
                inline_keyboard: inline_keyboard
              }
            end
            query
          end
        end
      end
    end
  end
end
