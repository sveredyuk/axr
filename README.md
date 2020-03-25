# AXR

**Ruby architecture for simplicity and team adoption**

Architecture's hard. It’s very easy to build a complex system. Much harder to build a simple and adaptable solution. The code doesn't matter. Coding for the sake of writing code is foolish.

Only a few of us get to write software that survives 5-10 years or longer. 90% of our work is garbage that becomes obsolete in 1-3 years after release. Most of our work hours are wasted on features that will never be useful.

This is just a reality.


(c) Volodya Sveredyuk

## Motivation
Application engineering it's always about abstractions and how they describe the real world and business which pays our salaries for coding something that might improve it. Maybe. Sometimes.

I hate doing something alone. I am a team player and as a team player, I prefer conventions over configuration. But this is not working with knowledge responsibility segregation inside the software app. In the Ruby world (especially Rails) it's so easy to add a new feature. Just add one line, one dependency, one callback and now you share knowledge about one entity into another entity. More dependencies - more spaghetti and legacy that in future we should REWRITE EVERYTHING!

<img src="docs/images/rewrite.png" alt="drawing" width="500"/>

Architecture's about knowledge responsibility and not the code.

The worst thing that even we write the architecture document wherein convenient way to agree on architecture and layers and entities, etc - We are not protected from violation of these conventions.

And this the place where AxR comes on stage.

Please, welcome the **DSL** that helps:
1. Describes your application layers (modules)
2. Defines knowledge responsibilities between them
3. Checks if you did not violate anything

## Setup

In your Gemfile
```ruby
gem 'axr'
```

## DSL

In your ruby app: (for rails app put it into `config/initializers/axr.rb` file)
```ruby
require 'axr'

AxR.app.define do
  layer 'Api'
  layer 'YourBusinessLogic'
  layer 'Repo'
end
```

By default, layers will get level from top to bottom.
```
Api -> 0
YourBusinessLogic -> 1
Repo -> 2
```

Layers with lower-level have less isolation.

- `Api` knows about `YourBusinessLogic` and `Repo`
- `YourBusinessLogic` knows about `Repo` but don't know anything about `Api`
- `Repo` fully isolated and don't familiar with `Api` and `YourBusinessLogic`

**Options**

```ruby
require 'axr'

AxR.app.define do
  layer 'A'
  layer 'B', familiar_with: 'C'
  layer 'C', familiar_with: 'B'
  layer 'D', isolated: true
  layer 'E', isolated: true
end
```

```ruby

# app.define options
AxR.app.define(isolated: true) # All layers will be isolated by default
AxR.app.define(familiar_with: ['D', 'E') # All layers will be familiar with D and E by default

# layer options
familiar_with: [...] # Can operate with other layers
isolated: true # 100% isolated and should not operate with other layers
isolated: true, familiar_with: [...] # Isolated from all except familiars
```

Can organize knowledge structure like:

<img src="docs/images/abcde_example.png" alt="drawing" width="500"/>

## CLI

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

Finish scanning with status code 1 in case of any warnings (you can use in CI environment to fail pipeline step)
```sh
axr check --exit-on-warnings
```

## More examples

**ERP system**

<img src="docs/images/erp_example.png" alt="drawing" width="500"/>

```ruby
if Rails.env.development? || Rails.env.test?
  require 'axr'

  AxR.app.define(isolated: true) do
    layer 'UI',         familiar_with: %w[Docs Inventory Production]
    layer 'API',        familiar_with: %w[Docs Inventory Production]
    layer 'Docs',       familiar_with: %w[Inventory Accounts Repo]
    layer 'Accounts',   familiar_with: %w[Repo]
    layer 'Inventory',  familiar_with: %w[Repo]
    layer 'Production', familiar_with: %w[Repo]
    layer 'Repo'
  end
end

```

### TODO
- Ignore vendor or any other directories dir as configuration
- Add sublayers
- Add rubocop cop
- Add more app examples
- Migrate to AST analyzer

