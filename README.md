[![Gem Version](https://badge.fury.io/rb/guard-pushover.png)](http://badge.fury.io/rb/guard-pushover)
[![Build Status](https://travis-ci.org/joenas/preek.png)](https://travis-ci.org/joenas/guard-pushover)
[![Coverage Status](https://coveralls.io/repos/joenas/guard-pushover/badge.png?branch=master)](https://coveralls.io/r/joenas/guard-pushover)
[![Dependency Status](https://gemnasium.com/joenas/guard-pushover.png)](https://gemnasium.com/joenas/guard-pushover)

# Guard::Pushover

Send [Pushover](https://pushover.net/) notifications with Guard!

## Installation

    $ gem install guard-pushover
    
or

    # Add to Gemfile
    gem 'guard/pushover

or install it yourself

    $ git clone git@github.com:joenas/guard-pushover.git
    $ cd guard-pushover
    $ rake install
    

## Usage

To generate template: 
 
    $ guard init pushover

### Examples
```ruby
# Give the filename as it is
guard :pushover, :api_key => '', :user_key => '' do
  watch(/lib\/(.*).rb/)
end
#=> "file.rb was changed"

# Custom message
guard :pushover, :message => "Yo! I just changed %s!", :api_key => '', :user_key => '' do
  watch(/lib\/(.*).rb/)
end
#=>  "Yo! I just changed file.rb!"

# Do something with the filename before giving it to Pushover
guard :pushover, :api_key => '', :user_key => '' do
  watch(/lib\/(.*).rb/) { |match| match[0].uppercase }
end
#=> "FILE.RB was changed"
```

### Available options

``` ruby
:title => 'Title'            # Custom title, default is 'Guard'
:priority => 1               # Priority, default is 0
:message => "Filename: %s"   # Custom message, using sprintf. 
:ignore_additions => true    # Ignores added files
:ignore_changes => true      # Ignores changed files
:ignore_removals => true     # Ignores removed files

```

Read more on [Pushover API](https://pushover.net/api).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
