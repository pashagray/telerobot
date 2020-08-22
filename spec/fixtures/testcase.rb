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