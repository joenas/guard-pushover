[![Build Status](https://travis-ci.org/joenas/preek.png)](https://travis-ci.org/joenas/guard-pushover)
[![Coverage Status](https://coveralls.io/repos/joenas/guard-pushover/badge.png?branch=master)](https://coveralls.io/r/joenas/guard-pushover)


# Guard::Pushover

Send [Pushover](https://pushover.net/) notifications with Guard!

## Installation

Install it yourself as:

    $ git clone git@github.com:joenas/guard-pushover.git

    $ cd guard-pushover

    $ rake install
    
Gem will be available soon.

## Usage

To generate template: `guard init pushover` 

### Example
```ruby
guard :pushover, :api_key => '', :user_key => '' do
  watch(/lib\/(.*).rb/)
end
```

### Available options

``` ruby
:title => 'Title'            # Custom title, default is 'Guard'
:priority => 1               # Priority, default is 0
```

Read more on [Pushover API](https://pushover.net/api).

Guard::Pushover will send a message like "[filename] was changed/removed/added".
Support will be added for custom messages.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
