# frozen_string_literal: true

RSpec.describe Telerobot::Telegram::Api do
  it "requires chat id and token for initialize" do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  describe "#send_message" do
    describe "when token and chat id valid" do
      let(:token) { "token" }
      let(:chat_id) { -1002387 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "return success response" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
          .to_return(status: 200, body: File.read("spec/fixtures/send_message_ok.json"))
        expect(api.send_message("I'm message", {})).to be_a(Net::HTTPOK)
      end
    end

    describe "when token invalid" do
      let(:token) { "invalidtoken" }
      let(:chat_id) { -1002387 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "return unauthorized error" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
          .to_return(status: 401, body: { ok: false, error_code: 401, description: "Unauthorized" }.to_json)
        expect(api.send_message("I'm message", {})).to be_a(Net::HTTPUnauthorized)
      end
    end

    describe "when chat not found" do
      let(:token) { "token" }
      let(:chat_id) { -10041265 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "return bad request error" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
          .to_return(status: 400, body: { ok: false, error_code: 400, description: "Bad Request: chat not found" }.to_json)
        expect(api.send_message("I'm message", {})).to be_a(Net::HTTPBadRequest)
      end
    end

    describe "when with invalid reply markup" do
      let(:token) { "token" }
      let(:chat_id) { -10041265 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "returns bad request error" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message", reply_markup: {keyboard: { text: "Button" }} }.to_json)
          .to_return(status: 400, body: { ok: false, error_code: 400, description: "Bad Request" }.to_json)
        expect(api.send_message("I'm message", { reply_markup: { keyboard: { text: "Button" }}})).to be_a(Net::HTTPBadRequest)
      end
    end
  end
end
