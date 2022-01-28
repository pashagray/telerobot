# frozen_string_literal: true

module Telerobot
  # https://core.telegram.org/bots/api#inlinekeyboardbutton
  class InlineKeyboardButton
    def initialize(
      text:,
      url: nil,
      login_url: nil,
      callback_data: nil,
      switch_inline_query_current_chat: nil,
      callback_game: nil,
      pay: nil
    )
      @text = text
      @url = url
      @login_url = login_url
      @callback_data = callback_data
      @switch_inline_query_current_chat = switch_inline_query_current_chat
      @callback_game = callback_game
      @pay = pay
    end

    def markup
      {
        text: @text,
        url: @url,
        login_url: @login_url,
        callback_data: @callback_data,
        switch_inline_query_current_chat: @switch_inline_query_current_chat,
        callback_game: @callback_game,
        pay: @pay
      }.filter { |_, v| !v.nil? }
    end
  end
end
