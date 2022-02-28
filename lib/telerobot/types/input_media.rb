# frozen_string_literal: true

module Telerobot
  module Types
    class InputMedia < Base
      attribute :media, String
      attribute :caption, String
      attribute :parse_mode, String
    end
  end
end
