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

    context "with TelegramFile storing" do
      let(:session_class) { Telerobot::SessionMock }
      let(:file_storage_class) { Telerobot::TelegramFileLock }
      let(:initial_state) { StartState }

      it "runs command for initial state" do
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

          Telerobot.run(
            params,
            initial_state: initial_state,
            session_class: session_class,
            telegram_file_storage: {
              storage_class: session_class,
              find_method: :find_by_file_path,
              save_method: :new,
              telegram_id_attr: :file_id,
              file_path_attr: :file_path
            }
        )

        expect(Telerobot::TelegramFileLock)
      end
    end
  end
end
