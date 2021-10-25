# frozen_string_literal: true

module Telerobot
  module Types
    class Contact < Base
      attribute :phone_number, String
      attribute :first_name, String
      attribute :last_name, String
      attribute :user_id, Integer
    end
  end
end
