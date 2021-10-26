# frozen_string_literal: true

module Telerobot
  module Types
    class Base
      IMMEDIATE_TYPES = [
        Integer,
        Float,
        String,
        TrueClass,
        FalseClass,
        NilClass,
        Boolean
      ].freeze

      def self.attribute(attribute, type)
        define_method(attribute) do
          instance_variable_get(:"@#{attribute}")
        end

        define_method(:"#{attribute}=") do |value|
          # For array_of(type)
          if type.is_a?(Hash)
            instance_variable_set(:"@#{attribute}", [])
            value.each do |elem|
              instance_variable_set(
                :"@#{attribute}",
                instance_variable_get(:"@#{attribute}") + [IMMEDIATE_TYPES.include?(type[:type]) ? elem : type[:type].new(elem)]
              )
            end
          elsif value.is_a?(type)
            instance_variable_set(:"@#{attribute}", value)
          # For singular values
          else
            instance_variable_set(:"@#{attribute}", IMMEDIATE_TYPES.include?(type) ? value : type.new(value))
          end
        end
      end

      def self.array_of(type)
        {
          type: type
        }
      end

      def initialize(attributes = {})
        attributes.each do |attribute, value|
          send("#{attribute}=", value) if respond_to?(attribute)
        end
      end
    end
  end
end
