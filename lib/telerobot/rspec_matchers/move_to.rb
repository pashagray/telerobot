RSpec::Matchers.define :move_to do |expected_state|
  match do |actual|
    @initial_state_name = actual.class.name
    @session = Telerobot::SessionMock.new(chat_id: 1, state: actual.class.name)
    actual.call({ text: @command, chat: { id: @session.chat_id } }, {}, @session)
    @session.state == expected_state.name
  end

  chain :on_command do |command|
    @command = command
  end

  failure_message do |actual|
    if @session.state == @initial_state_name
      <<~HEREDOC
        expected that #{@initial_state_name} is moved to #{expected} state
        on command #{@command}, but state not changed

        expected:
          #{@initial_state_name} -> #{expected}
        actual:
          Not changed
      HEREDOC
    else
      <<~HEREDOC
        expected that #{@initial_state_name} is moved to #{expected} state
        on command #{@command}, but wrong state transisition occured

        expected:
          #{@initial_state_name} -> #{expected}
        actual:
          #{@initial_state_name} -> #{@session.state}
      HEREDOC
    end
  end
end
