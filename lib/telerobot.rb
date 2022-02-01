# frozen_string_literal: true

require "net/http"
require "json"
require "telerobot/version"
require "telerobot/utils"
require "telerobot/config"
require "telerobot/session_mock"
require "telerobot/state"
require "telerobot/keyboard_button"
require "telerobot/inline_keyboard_button"
require "telerobot/reply_keyboard_markup"
require "telerobot/inline_keyboard_markup"
require "telerobot/commands/edit_message_text"
require "telerobot/commands/send_message"
require "telerobot/commands/send_photo"
require "telerobot/errors/file_not_found"
require "telerobot/no_keyboard_markup"
require "telerobot/types/boolean"
require "telerobot/types/base"
require "telerobot/types/chat"
require "telerobot/types/user"
require "telerobot/types/contact"
require "telerobot/types/location"
require "telerobot/types/photo_size"
require "telerobot/types/sticker"
require "telerobot/types/message"
require "telerobot/types/callback_query"
require "telerobot/api"
require "telerobot/telegram/response"

module Telerobot
  class Error < StandardError; end

  def run(query, initial_state:, session_class:)
    symbolized_query = Utils.deep_symbolize_keys(query)
    callback_query = symbolized_query[:callback_query] || {}
    message = symbolized_query[:message] || {}
    chat = message[:chat] || callback_query[:message][:chat]
    session = session_class.find_or_create_by(chat_id: chat[:id])
    state_class = session.state ? session.state.constantize : initial_state
    state_class.new.call(message, callback_query, session)
  end

  module_function :run
end
