require_relative "./fixtures/testcase"

RSpec.describe Telerobot do
  describe ".run" do
    context "with /start message" do
      let(:params) do
        {
          "message" => {
            "text" => "/start",
            "chat" => {
              "id" => 1
            }
          }
        }
      end

      let(:session_class) { Telerobot::SessionMock }
      let(:initial_state) { StartState }

      it "runs command for initial state" do
        expect {
          Telerobot.run(params, initial_state: initial_state, session_class: session_class)
        }.to output("start method invoked!").to_stdout
      end
    end

    context "with callback_query" do
      let(:params) do
        {
          "callback_query" => {
            "data" => "/start",
            "message" => {
              "text" => "From inline keyboard",
              "chat" => {
                "id" => 1
              }
            }
          }
        }
      end

      let(:session_class) { Telerobot::SessionMock }
      let(:initial_state) { StartState }

      it "runs command for initial state" do
        expect {
          Telerobot.run(params, initial_state: initial_state, session_class: session_class)
        }.to output("start method invoked!").to_stdout
      end
    end
  end
end
