# frozen_string_literal: true

require_relative "../fixtures/testcase"

RSpec.describe Telerobot::State do
  describe "#call" do
    let(:session) { Telerobot::SessionMock.new(chat_id: 1) }

    describe "command /start" do
      let(:message) { { chat_id: 1, text: "/start" } }

      it "accepts /start command and calls #start method" do
        expect { StartState.new.call(message, {}, session) }
          .to output("start method invoked!").to_stdout
      end
    end

    describe "regex for mapping commands" do
      context "pattern 1" do
        let(:message) { { chat_id: 1, text: "1234" } }

        it "accepts command and maps it to method via regex" do
          expect { StartState.new.call(message, {}, session) }
            .to output("regex_one method invoked!").to_stdout
        end
      end
    end

    describe "regex for mapping commands" do
      context "pattern 2" do
        let(:message) { { chat_id: 1, text: "abccba" } }

        it "accepts command and maps it to method via regex" do
          expect { StartState.new.call(message, {}, session) }
            .to output("regex_two method invoked!").to_stdout
        end
      end
    end

    describe "move to other state" do
      let(:message) { { chat_id: 1, text: "Second" } }

      it "accepts Second command and changes state to SecondScreenState" do
        StartState.new.call(message, {}, session)
        expect(session.state).to eq("SecondScreenState")
      end

      it "calls before_exit while moving to new state" do
        expect { StartState.new.call(message, {}, session) }
          .to output(/Exiting StartState state/)
          .to_stdout
      end

      it "calls before_enter while moving to new state" do
        expect { StartState.new.call(message, {}, session) }
          .to output(/Entering SecondScreenState state start/)
          .to_stdout
      end

      it "calls after_enter while moving to new state" do
        expect { StartState.new.call(message, {}, session) }
          .to output(/Entering SecondScreenState state finish/)
          .to_stdout
      end
    end

    describe "shared commands" do
      let(:message) { { chat_id: 1, text: "/shared_command" } }

      it "uses command from parent class" do
        expect { StartState.new.call(message, {}, session) }
        .to output(/Shared command is called/)
        .to_stdout
      end
    end

    describe "unknown command" do
      let(:message) { { chat_id: 1, text: "bad_command" } }

      it "raises error with help" do
        expect { StartState.new.call(message, {}, session) }
          .to raise_error(Telerobot::Error)
          .with_message(
            <<~HEREDOC
              Unknown command +bad_command+

              Add it command_mapping:
              command_mapping({
                "bad_command" => :your_method_to_be_ivoked
              })

              Also you can override unkown_command method to handle
              such errors. Example:

              def unknown_command
                # your_logic
              end
            HEREDOC
          )
      end
    end

    describe "command with missing method" do
      let(:message) { { chat_id: 1, text: "Missing method" } }

      it "raises error with help" do
        expect { StartState.new.call(message, {}, session) }
          .to raise_error(Telerobot::Error)
          .with_message(
            <<~HEREDOC
              Command +Missing method+ found, but correspoing method does not exist

              Add method to your state:
              def you_have_forgotten_me
                # your logic
              end
            HEREDOC
          )
      end
    end
  end

  describe "#current_chat" do
    let(:state) { StartState.new }

    before do
      allow(state).to receive(:session).and_return(OpenStruct.new(chat_id: 1))
    end

    it "return Chat class object" do
      expect(state.current_chat).to be_an_instance_of(Telerobot::Chat)
    end
  end

  describe ".configure" do
    let(:session) { Telerobot::SessionMock.new(chat_id: 1) }
    let(:message) { { chat_id: 1, text: "/shared_command" } }

    describe "when configure not defined in base state" do
      class Base; include Telerobot::State end
      class CustomState < Base
        command_mapping({ "/shared_command" => :shared_command })
        def shared_command
          print "shared command"
        end
      end

      it "raise error around initializer" do
        expect{ CustomState.new.call(message, {}, session) }
          .to raise_error(Telerobot::Error)
          .with_message(
            <<~HEREDOC
              Bot token must be provided.
              You should configure your class with telegram bot token
              Add to your CustomState class configure class method
              Example:
                class CustomState
                  include Telerobot::State

                  configure do |config|
                    config.bot_token = "token"
                  end
                end
            HEREDOC
          )
      end
    end

    describe "when configure defined" do
      it "uses config from parent class" do
        state = StartState.new
        expect(state.class.config).to be_a(Telerobot::Config)
        expect(state.class.config.bot_token).to eq("token")
      end

      it "available configure two and more telegram bots" do
        expect(StartState.config.bot_token).to eq("token")
        expect(SecondScreenState.config.bot_token).to eq("another token")
      end
    end
  end
end
