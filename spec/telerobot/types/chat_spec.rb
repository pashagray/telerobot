# frozen_string_literal: true

RSpec.describe Telerobot::Types::Chat do
  describe "#message" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @command instance variable" do
      expect(chat.add_message("I'm message!")).to be_an_instance_of(Telerobot::Types::Chat)
      expect(chat.instance_variable_get(:@command)).to be_a Telerobot::Commands::SendMessage
    end
  end

  describe "#photo" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @command instance variable" do
      expect(chat.add_photo("spec/fixtures/robot.png")).to be_an_instance_of(Telerobot::Types::Chat)
      expect(chat.instance_variable_get(:@command)).to be_a Telerobot::Commands::SendPhoto
    end
  end

  describe "#keyboard" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    it "return object with inserted @keyboard instance variable" do
      expect(chat.add_keyboard([["First button"]])).to be_an_instance_of(Telerobot::Types::Chat)
      expect(chat.instance_variable_get(:@keyboard)).to be_an_instance_of(Telerobot::ReplyKeyboardMarkup)
    end
  end
end
