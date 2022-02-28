# frozen_string_literal: true

module Telerobot
  module Types
    class InputMediaPhoto < Base
      attribute :type, String
      attribute :media, String
      attribute :caption, String
      attribute :parse_mode, String
    end
  end
end
