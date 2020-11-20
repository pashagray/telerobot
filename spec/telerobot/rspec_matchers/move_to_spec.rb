# frozen_string_literal: true
require_relative "../../../lib/telerobot/rspec_matchers/move_to"
require_relative "../../fixtures/testcase"

RSpec.describe "move_to rspec matcher" do
  let(:state) { StartState.new }
  it "handles positive match correctly" do
    expect(state).to move_to(SecondScreenState).on_command("Second")
  end

  it "handles negative match correctly" do
    expect(state).not_to move_to(SecondScreenState).on_command("/start")
  end

  context "state does not changed" do
    it "renders readable error" do
      expect { expect(state).to move_to(SecondScreenState).on_command("/start") }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError)
        .with_message(
          <<~HEREDOC
            expected that StartState is moved to SecondScreenState state
            on command /start, but state not changed

            expected:
              StartState -> SecondScreenState
            actual:
              Not changed
          HEREDOC
        )
    end
  end

  context "wrong state changed" do
    it "renders readable error" do
      expect { expect(state).to move_to(SettingsScreen).on_command("Second") }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError)
        .with_message(
          <<~HEREDOC
            expected that StartState is moved to SettingsScreen state
            on command Second, but wrong state transisition occured

            expected:
              StartState -> SettingsScreen
            actual:
              StartState -> SecondScreenState
          HEREDOC
        )
    end
  end
end
