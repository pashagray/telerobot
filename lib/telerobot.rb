# frozen_string_literal: true

require "net/http"
require "json"
require "telerobot/version"
require "telerobot/utils"
require "telerobot/config"
require "telerobot/session_mock"
require "telerobot/chat"
require "telerobot/state"
require "telerobot/reply_keyboard_markup"
require "telerobot/commands/send_message"
require "telerobot/commands/send_photo"
require "telerobot/no_keyboard_markup"
require "telerobot/api"
require "telerobot/telegram/response"

module Telerobot
  class Error < StandardError; end

  def run(query, initial_state:, session_class:)
    symbolized_query = Utils.deep_symbolize_keys(query)
    message = symbolized_query[:message]
    chat = message[:chat]
    session = session_class.find_or_create_by(chat_id: chat[:id])
    state_class = session.state ? session.state.constantize : initial_state
    state_class.new.call(message, {}, session)
  end

  module_function :run
end
