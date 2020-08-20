module Telerobot
  class Config
    def self.set(args = {})
      @args = args.transform_keys(&:to_sym)
    end

    def self.bot_token
      token = (@args || {})[:bot_token]
      
      raise Error, "Bot token must be provided. Try Telerobot::Config.set({ bot_token: 'your_token' })" unless token

      token
    end
  end
end
