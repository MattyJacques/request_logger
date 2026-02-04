# RequestLogger

A simple Ruby gem that automatically logs HTTP requests and responses made using `Net::HTTP`. It is designed to help developers debug external API integrations by providing visibility into the traffic leaving and entering their application.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add request_logger
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install request_logger
```

## Usage

Simply require the gem in your project. It automatically patches `Net::HTTP` to intercept and log requests.

```ruby
require 'request_logger'

# Make a request as usual
Net::HTTP.get(URI('https://www.example.com'))
```

By default, the gem will output logs to `STDOUT`.

## Configuration

You can configure what information gets logged by using the `configure` block.

```ruby
RequestLogger.configure do |config|
  # Log when a connection is established (Default: false)
  config.log_connection = true

  # Log the request details (method, path, body) (Default: true)
  config.log_request = true

  # Log the response details (status code, body) (Default: true)
  config.log_response = true

  # Log request and response headers (Default: false)
  config.log_headers = true
end
```

### Defaults

| Option           | Default | Description                                      |
|------------------|---------|--------------------------------------------------|
| `log_connection` | `false` | Logs the host and port when a connection opens.  |
| `log_request`    | `true`  | Logs the HTTP method, URL, and request body.     |
| `log_response`   | `true`  | Logs the response status code and body.          |
| `log_headers`    | `false` | Includes headers in the request/response logs.   |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MattyJacques/request_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/MattyJacques/request_logger/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RequestLogger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MattyJacques/request_logger/blob/main/CODE_OF_CONDUCT.md).
