RSpec::Matchers.define :move_to do |expected_state|
  match do |actual|
    session = Telerobot::SessionMock.new(chat_id: 1, state: actual.class.name)
    actual.call({ text: @command, chat: { id: session.chat_id } }, {}, session)
    session.state == expected_state.name
  end

  chain :on_command do |command|
    @command = command
  end
end