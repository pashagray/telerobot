# frozen_string_literal: true

RSpec.describe Telerobot::Chat do
  describe ".new" do
    it "requires two keyword arguments chat_id & token" do
      expect{ described_class.new() }.to raise_error(ArgumentError)
      expect(described_class.new(chat_id: 1, token: "token")).to be_an_instance_of(Telerobot::Chat)
    end
  end

  describe "#message" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @message instance variable" do
      expect(chat.message("I'm message!")).to be_an_instance_of(Telerobot::Chat)
      expect(chat.instance_variable_get(:@message)).to eq "I'm message!"
    end
  end

  describe "#keyboard" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @keyboard instance variable" do
      expect(chat.keyboard([["First button"]])).to be_an_instance_of(Telerobot::Chat)
      expect(chat.instance_variable_get(:@keyboard)).to match_array([["First button"]])
    end
  end

  describe "#inline_keyboard" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @keyboard instance variable" do
      expect(chat.inline_keyboard([["Inline button"]])).to be_an_instance_of(Telerobot::Chat)
      expect(chat.instance_variable_get(:@inline_keyboard)).to match_array([["Inline button"]])
    end
  end
end
