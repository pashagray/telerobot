# Telerobot

Microframework to develop easy scalable and stateful telegram bots with ruby! Works perfectly with Rails, but Rails-agnostic by design.

```ruby
class IntroState
  include Telerobot::State

  command_mapping({
    "/start" => :menu
  })

  def menu
    move_to MenuState
  end
end

class MenuState
  include Telerobot::State

  command_mapping({
    "I'm lucky!" => :random,
    "Back" => :back,
    /[A-Za-z\s]+/ => :search
  })

  def after_enter
    current_chat
      .message("Type author name to find cool books or try your luck")
      .keyboard([["I'm lucky!"]])
      .send_now
  end

  def random
    # your logic
  end

  def back
    move_to IntroState
  end

  def search
    # your logic
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'telerobot'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install telerobot

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/telerobot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/telerobot/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Telerobot project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/telerobot/blob/master/CODE_OF_CONDUCT.md).
