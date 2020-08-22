module Telerobot
  class SessionMock
    attr_accessor :chat_id, :state

    def self.find_or_create_by(chat_id:)
      new(chat_id: chat_id)
    end
    
    def initialize(chat_id:, state: nil)
      @chat_id = chat_id
      @state = state
    end

    def update(state: nil)
      @state = state if state
    end
  end
end