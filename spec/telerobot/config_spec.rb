RSpec.describe Telerobot::Config do
  describe ".bot_token" do
    context "when token is not set" do
      it "raises error" do
        expect { described_class.bot_token }
          .to raise_error(Telerobot::Error)
          .with_message("Bot token must be provided. Try Telerobot::Config.set({ bot_token: 'your_token' })")
      end
    end

    context "when token is set" do
      it "returns token" do
        described_class.set({ bot_token: "xxx" })
        expect(described_class.bot_token).to eq("xxx")
      end
    end
  end
end
