# CountOnce-ruby

Wrapper for the CountOnce API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'countonce-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install countonce-ruby

## Usage

### Ping
```ruby
require "countonce"

co_client = CountOnce.new({
  account_id: "<account_id>",
  auth_token: "<your api auth token>"
})

begin

  response = co_client.ping({
    key: "<key>",
    attributes: {
      account_id: "<attribute value>",
      action: "<attribute value>"
    },
    unique_value: "<unique id or hash>",
    revenue: 0.00
  })
  puts response.json

rescue StandardError => e
  puts e.message

end
```

>The '.then' function only works on Windows for now. Hence, the following example is Windows only.

```ruby
require "countonce"

co_client = CountOnce.new({
  account_id: "<account_id>",
  auth_token: "<your api auth token>"
})

begin

  co_client.async.ping({
    key: "<key>",
    attributes: {
      account_id: "<attribute value>",
      action: "<attribute value>"
    },
    unique_value: "<unique id or hash>",
    revenue: 0.00
  }).then {|response| puts response.value.json}

rescue StandardError => e
  puts e.message

end
```

### Query
```ruby
require "countonce"

co_client = CountOnce.new({
  account_id: "<account_id>", 
  auth_token: "<your api auth token>"
})

query_options = {
  metric: "daily"
}

begin

  data = co_client.getUniques("<key>", query_options)
  p data.json

rescue StandardError => e
  puts e.message

end
```

>Same case as for the ping example. You can use the ```then``` function but only with Windows.

```ruby
require "countonce"

co_client = CountOnce.new({
  account_id: "<account_id>", 
  auth_token: "<your api auth token>"
})

query_options = {
  metric: "daily"
}

begin

  co_client.async.getUniques("<key>", query_options).then {|data|
    p data.value.json
  }

rescue StandardError => e
  puts e.message

end
```

For more information on async, please refer to the concurrent-ruby's documentation.
