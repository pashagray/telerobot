require "net/http"
require "json"

module Telerobot
  class Chat
    def initialize(chat_id)
      @uri = URI("https://api.telegram.org/bot#{Config.bot_token}/sendMessage")
      @chat_id = chat_id
      @message = nil
      @keyboard = nil
      @inline_keyboard = nil
    end

    def message(message)
      @message = message
      self
    end

    def keyboard(keyboard, onetime: false)
      @keyboard = keyboard
      @one_time_keyboard = onetime
      self
    end

    def inline_keyboard(keyboard)
      @inline_keyboard = keyboard
      self
    end

    def send_now
      query = { chat_id: @chat_id }
      query[:text] = @message if @message
      if @keyboard
        query[:reply_markup] = {
          keyboard: @keyboard,
          one_time_keyboard: @one_time_keyboard
        }
      end
      if @inline_keyboard
        query[:reply_markup] = {
          inline_keyboard: @inline_keyboard
        }
      end
      request!(query)
    end

    def request!(query)
      Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(@uri)
        req['Content-Type'] = "application/json"
        req.body = query.to_json
        http.request(req)
      end
    end
  end
end