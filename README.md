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
  account_id: "account1",
  auth_token: "<your api auth token>"
})

begin

  co_client.async.ping({
    key: "account_action",
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
  account_id: "account1", 
  auth_token: "<your api auth token>"
})

query_options = {
  metric: daily
}
begin

  co_client.async.getUniques("account_action", query_options).then do |data|
    data = data.value.json
    data.each do |item|
      puts item["attributes"]
    end 
  end

rescue StandardError => e
  puts e.message

end
```
