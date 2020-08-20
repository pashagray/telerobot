require "json"

module Telerobot
  class Utils
    # We can't use transform_keys because we want to support
    # old ruby versions (<2.5). Also we can't use deep_symbolize_keys
    # provided by ActiveSupport, because we want gem to be rails agnostic
    # and have as little dependencies as possible.
    def self.deep_symbolize_keys(hash)
      hash.reduce({}) do |acc, (key, value)|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? deep_symbolize_keys(value) : value
        acc[new_key] = new_value
        acc
      end
    end
  end    
end
