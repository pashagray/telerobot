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
      expect(chat.instance_variable_get(:@keyboard)).to be_an_instance_of(Telerobot::ReplyKeyboardMarkup)
    end
  end

  describe "#send_now" do
    let(:chat) { described_class.new(chat_id: 1, token: "token") }

    context "plain message" do
      # https://core.telegram.org/bots/api#sendmessage
      it "sends plain message" do
        stub_request(:post, "https://api.telegram.org/bottoken/sendMessage").with(
          body: { chat_id: 1, text: "Test message" }.to_json,
          headers: { "Content-Type" => "application/json" }
        ).to_return(status: 200, body: File.read("spec/fixtures/send_message_ok.json"))

        resp = chat.message("Test message").send_now
        expect(resp.success?).to eq(true)
        expect(resp.body.dig(:result, :text)).to eq("Test message")
      end
    end

    context "plain message with reply (general) keyboard" do
      # https://core.telegram.org/bots/api#replykeyboardmarkup

      it "sends plain message" do
        stub_request(:post, "https://api.telegram.org/bottoken/sendMessage").with(
          body: { chat_id: 1, text: "Test message", reply_markup: { keyboard: [["a"]], one_time_keyboard: true, resize_keyboard: false } }.to_json,
          headers: { "Content-Type" => "application/json" }
        ).to_return(status: 200, body: File.read("spec/fixtures/send_message_ok.json"))

        resp = chat.message("Test message").keyboard([["a"]], one_time: true).send_now
        expect(resp.success?).to eq(true)
        expect(resp.body.dig(:result, :text)).to eq("Test message")
      end
    end
  end
end
