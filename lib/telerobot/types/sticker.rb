# frozen_string_literal: true

module Telerobot
  module Types
    class Sticker < Base
      attribute :file_id, String
      attribute :file_unique_id, String
      attribute :width, Integer
      attribute :height, Integer
      attribute :is_animated, Boolean
      attribute :thumb, PhotoSize
      attribute :emoji, String
      attribute :set_name, String
      attribute :file_size, Integer
    end
  end
end
