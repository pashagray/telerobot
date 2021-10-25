# frozen_string_literal: true

module Telerobot
  module Types
    Location = Struct.new(
      :longitude,
      :latitude,
      :horizontal_accuracy,
      :live_period,
      :heading,
      :proximity_alert_radius,
      keyword_init: true
    )
  end
end
