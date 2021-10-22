# frozen_string_literal: true

RSpec.describe Telerobot::Telegram::Api do
  it "requires chat id and token for initialize" do
    expect { described_class.new }.to raise_error(ArgumentError)
  end

  describe "#send_message" do
    context "when token invalid" do
      let(:token) { "invalidtoken" }
      let(:chat_id) { -1002387 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "return unauthorized error" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
          .to_return(status: 401, body: { ok: false, error_code: 401, description: "Unauthorized" }.to_json)
        res = api.send_message("I'm message")

        expect(res.success?).to eq(false)
        expect(res.error).to eq("Unauthorized")
        expect(res.code).to eq(401)
      end
    end

    context "when chat not found" do
      let(:token) { "token" }
      let(:chat_id) { -10041265 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      it "return bad request error" do
        stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
          .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
          .to_return(status: 400, body: { ok: false, error_code: 400, description: "Bad Request: chat not found" }.to_json)

        res = api.send_message("I'm message")

        expect(res.success?).to eq(false)
        expect(res.error).to eq("Bad Request: chat not found")
        expect(res.code).to eq(400)
      end
    end

    context "when token and chat id valid" do
      let(:token) { "token" }
      let(:chat_id) { -1002387 }
      let(:api) { Telerobot::Telegram::Api.new(chat_id, token) }

      context "without keyboard" do
        it "return success response" do
          stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
            .with(body: { chat_id: chat_id, text: "I'm message" }.to_json, headers: { "Content-Type" => "application/json" })
            .to_return(status: 200, body: File.read("spec/fixtures/send_message_ok.json"))

            res = api.send_message("I'm message")

            expect(res.success?).to eq(true)
            expect(res.error).to eq(nil)
            expect(res.code).to eq(200)
        end
      end

      context "with keyboard" do
        it "return success response" do
          stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
            .with(body: { chat_id: chat_id, text: "I'm message", reply_markup: { keyboard: [["a", "b"], ["c"]], one_time_keyboard: false, resize_keyboard: false } }.to_json, headers: { "Content-Type" => "application/json" })
            .to_return(status: 200, body: File.read("spec/fixtures/send_message_ok.json"))
          expect(api.send_message("I'm message", Telerobot::ReplyKeyboardMarkup.new([["a", "b"], ["c"]]))).to be_a(Telerobot::Telegram::Response)
        end
      end
    end
  end
end
