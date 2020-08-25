# frozen_string_literal: true

RSpec.describe Telerobot::Config do
  describe "#bot_token" do
    it "get or set value of token" do
      expect(subject.bot_token).to eq nil
      expect(subject.bot_token = "token").to eq("token")
    end
  end
end
