# frozen_string_literal: true

require_relative "../../fixtures/testcase"

RSpec.describe Telerobot::Telegram::Api do
  let(:chat) { Chat.include Telerobot::Telegram::Api }
  let(:chat_id) { "5894482" }
  let(:token) { "1295081136:AAFeO6O-nqz43wSYtKrD0RW_NEz60FdH-fd" }

  it "implement mixin facility" do
    expect(
      chat.new(chat_id: chat_id, token: token).respond_to?(:send_now)
    ).to eq true
  end

  describe "#send_now" do
    describe "when send with only message" do
      let(:response) {
        chat.new(chat_id: chat_id, token: token).message("I'm message").send_now
      }
      it "returns success result", vcr: { cassette_name: "send_message_ok", serialize_with: :json } do
        expect(JSON(response.body, symbolize_names: true)).to include(ok: true)
      end
    end

    describe "when send message with keyboard" do
      let(:response) {
        chat.new(chat_id: chat_id, token: token)
            .message("I'm message")
            .keyboard([["Button from VCR"]])
            .send_now
      }
      it "returns success result", vcr: { cassette_name: "send_message_ok", serialize_with: :json } do
        expect(JSON(response.body, symbolize_names: true)).to include(ok: true)
      end
    end

    describe "when send message with inline keyboard" do
      let(:response) {
        chat.new(chat_id: chat_id, token: token)
            .message("I'm message")
            .inline_keyboard([[{text: "Inline button from VCR", url: "http://example.com"}]])
            .send_now
      }
      it "returns success result", vcr: { cassette_name: "send_message_inline_keyboard_ok", serialize_with: :json } do
        expect(
          JSON(response.body, symbolize_names: true)
        ).to include(ok: true)
      end
    end

    describe "when send message with photo" do
      let(:response) {
        chat.new(chat_id: chat_id, token: token)
            .message("I'll open my casino with blackjack and whores!")
            .photo(File.open("spec/fixtures/robot.png"))
            .send_now
      }
      it "returns success result", vcr: { cassette_name: "send_photo_ok", serialize_with: :json } do
        expect(
          JSON(response.body, symbolize_names: true)
        ).to include(ok: true)
      end
    end
  end
end
