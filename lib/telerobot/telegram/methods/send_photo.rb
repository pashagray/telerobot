# frozen_string_literal: true

module Telerobot
  module Telegram
    module Methods
      class SendPhoto
        class << self
          def perform(chat_id, token, text, photo, reply_markup)
            uri = URI("https://api.telegram.org/bot#{token}/sendPhoto")

            res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
              req = Net::HTTP::Post.new(uri)
              req.set_form([
                ["chat_id", chat_id.to_s],
                ["photo", File.open(photo)],
                ["caption", text],
                ["parse_mode", "Markdown"],
                ["reply_markup", reply_markup[:reply_markup].to_json]
              ], "multipart/form-data")
              http.request(req)
            end

            Response.new(res)
          end
        end
      end
    end
  end
end
