# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendPhoto
        class << self
          def perform(chat_id, token, message, photo, reply_markup)
            uri = URI("https://api.telegram.org/bot#{token}/sendPhoto")
            body = reply_markup ? { "chat_id" => chat_id, "photo" => photo, "caption" => message, "parse_mode" => "Markdown", "reply_markup" => reply_markup } : { "chat_id" => chat_id, "photo" => photo, "caption" => message, "parse_mode" => "Markdown" }

            Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              post = Net::HTTP::Post.new(uri)
              post.set_form(body.to_a, "multipart/form-data")
              http.request(post)
            end
          end
        end
      end
    end
  end
end
