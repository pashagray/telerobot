# frozen_string_literal: true

module Telerobot
  module Types
    Contact = Struct.new(
      :phone_number,
      :first_name,
      :last_name,
      :user_id,
      :vcard,
      keyword_init: true
    )
  end
end
