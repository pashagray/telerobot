class SessionMock
  attr_accessor :chat_id, :state
  
  def initialize(chat_id:, state: nil)
    @chat_id = chat_id
    @state = state
  end

  def update(state: nil)
    @state = state if state
  end
end

class BaseState
  include Telerobot::State

  command_mapping({
    "/shared_command" => :shared_command
  })

  def shared_command
    print "Shared command is called"
  end
end

class StartState < BaseState
  command_mapping({
    "/start" => :start,
    /[0-9]+/ => :regex_one,
    /[abc]{6}/ => :regex_two,
    "Second" => :move_to_other_state_test,
    "Missing method" => :you_have_forgotten_me
  })

  def start
    print "start method invoked!"
  end

  def regex_one
    print "regex_one method invoked!"
  end

  def regex_two
    print "regex_two method invoked!"
  end

  def move_to_other_state_test
    move_to SecondScreenState
  end

  def before_exit
    print "Exiting #{self.class.name} state"
  end
end

class SecondScreenState < BaseState
  def before_enter
    print "Entering #{self.class.name} state start"
  end

  def after_enter
    print "Entering #{self.class.name} state finish"
  end
end

RSpec.describe Telerobot::State do
  describe "#call" do
    let(:session) { SessionMock.new(chat_id: 1) }

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
end