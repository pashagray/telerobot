require_relative "./fixtures/testcase"

RSpec.describe Telerobot do
  describe ".run" do
    context "with /start message" do
      let(:params) do
        {
          "chat" => {
            "id" => 1
          },
          "message" => {
            "text" => "/start"
          }
        }
      end

      let(:session_class) { SessionMock }
      let(:initial_state) { StartState }

      it "runs command for initial state" do
        expect {
          Telerobot.run(params, initial_state: initial_state, session_class: session_class)
        }.to output("start method invoked!").to_stdout
      end
    end
  end
end
