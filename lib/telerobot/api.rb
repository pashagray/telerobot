# frozen_string_literal: true

module Telerobot
  class Api
    def initialize(chat_id, token)
      @chat_id = chat_id
      @token = token
    end

    def request!(command, keyboard = NoKeyboardMarkup)
      uri = URI("https://api.telegram.org/bot#{@token}/#{command.method}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.set_debug_output($stderr)
      req = Net::HTTP::Post.new(uri)
      request_form = [["chat_id", @chat_id.to_s], ["reply_markup", keyboard.markup.to_json]] + command.body
      req.set_form(request_form, "multipart/form-data")
      res = http.request(req)

      Telegram::Response.new(JSON.parse(res.body, symbolize_names: true))
    end
  end
end
