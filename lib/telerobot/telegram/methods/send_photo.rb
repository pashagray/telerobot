# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendPhoto
        class << self
          def perform(chat_id, token, message, photos, keyboard, one_time_keyboard, inline_keyboard)
            uri = URI("https://api.telegram.org/bot#{token}/SendPhoto")
            query = build_query(chat_id, message, photos, keyboard, one_time_keyboard, inline_keyboard)
            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              req = Net::HTTP::Post.new(uri)
              req.set_form(query, "multipart/form-data")
              http.request(req)
            end
          end

          private

          def build_query(chat_id, message, photos, keyboard, one_time_keyboard, inline_keyboard)
            query = [
              ["chat_id", chat_id.to_s],
              ["photo", File.open(photos.first)],
              ["caption", message],
            ]
            if keyboard
              query.push(["reply_markup", { keyboard: keyboard, one_time_keyboard: one_time_keyboard }.to_json])
            end

            if inline_keyboard
              query.push(["reply_markup", { inline_keyboard: inline_keyboard }.to_json])
            end
            query
          end
        end
      end
    end
  end
end
