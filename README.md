# AXR

### Ruby applications architecture for simplicity and team adoption

Architecture is hard. It’s very easy to build a complex system; much harder to build a simple and adaptable one. The code doesn't matter and coding for the sake of writing code is foolish.

Few of us get to write software that survives 5-10 years or longer. 90% of our work is garbage that becomes obsolete 1-3 years after release. Most of our work hours are wasted on features that never get shipped.

This is just reality.

(c) Me

### Setup

```sh
gem install axr
```

or in your Gemfile:
```ruby
gem 'axr', '~> 0.5'
```

```sh
bundle install
```

Somewhere in your ruby app:
```ruby
require 'axr'

AxR.app.define do
  layer 'Api'
  layer 'YourBusinessLogic'
  layer 'Repo'
end
```

Run `AxR` checker in console
```sh
axr check . --load path/to/you/app/autoload.rb
```

For rails apps
```sh
axr check . --load config/environment
```

Run for a specific directory
```sh
axr lib/adapters
```

Run for a specific file
```sh
axr lib/adapters/youtube.rb
```

### How it works
...TODO

### TODO
- Add sublayers
