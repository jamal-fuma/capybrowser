# CapyBrowser

## Usage - Step 1 tell your application about capybrowser

Add this line to your application's Gemfile:
gem 'capybrowser'

## Create directories - we need to
$ ( [ -d 'vendor/cache' ] || mkdir -p vendor/cache; )

## Install Gems
$ bundle install --binstubs=tmp/vendor/bin --path=tmp/vendor/bundle

# Run Cucumber
rake clean                                                    # Clean generated files
rake features[opts]                                           # Run features against local test environment
rake features:hudson:http:int[command_line_arguments]         # Run features against int environment at host http://www.int.example.co.uk
rake features:hudson:http:live[command_line_arguments]        # Run features against live environment at host http://www.live.example.co.uk
rake features:hudson:http:production[command_line_arguments]  # Run features against production environment at host production.example.co.uk
rake features:hudson:http:stage[command_line_arguments]       # Run features against stage environment at host http://www.stage.example.co.uk
rake features:hudson:http:test[command_line_arguments]        # Run features against test environment at host http://www.test.example.co.uk
rake features:hudson:ssl:int[command_line_arguments]          # Run features against int environment at host https://www.ssl.int.example.co.uk
rake features:hudson:ssl:live[command_line_arguments]         # Run features against live environment at host https://www.ssl.live.example.co.uk
rake features:hudson:ssl:production[command_line_arguments]   # Run features against production environment at host production.example.co.uk
rake features:hudson:ssl:stage[command_line_arguments]        # Run features against stage environment at host https://www.ssl.stage.example.co.uk
rake features:hudson:ssl:test[command_line_arguments]         # Run features against test environment at host https://www.ssl.test.example.co.uk
rake features:local:http:int[command_line_arguments]          # Run features against int environment at host http://www.int.example.co.uk
rake features:local:http:live[command_line_arguments]         # Run features against live environment at host http://www.live.example.co.uk
rake features:local:http:production[command_line_arguments]   # Run features against production environment at host production.example.co.uk
rake features:local:http:stage[command_line_arguments]        # Run features against stage environment at host http://www.stage.example.co.uk
rake features:local:http:test[command_line_arguments]         # Run features against test environment at host http://www.test.example.co.uk
rake features:local:ssl:int[command_line_arguments]           # Run features against int environment at host https://www.ssl.int.example.co.uk
rake features:local:ssl:live[command_line_arguments]          # Run features against live environment at host https://www.ssl.live.example.co.uk
rake features:local:ssl:production[command_line_arguments]    # Run features against production environment at host production.example.co.uk
rake features:local:ssl:stage[command_line_arguments]         # Run features against stage environment at host https://www.ssl.stage.example.co.uk
rake features:local:ssl:test[command_line_arguments]          # Run features against test environment at host https://www.ssl.test.example.co.uk
rake features:sandbox[command_line_arguments]                 # Run features against sandbox environment at host sandbox.example.co.uk
rake gems:build                                               # Build the capybrowser gem
rake gems:capybrowser                                         # Build the capybrowser-0.0.2.gem
rake metrics:all                                              # Generate all metrics reports / Generate all metrics reports
rake tests                                                    # Generate unit test coverage report
