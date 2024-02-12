# Dirigera Hub API client

This gem implements an API client for the IKEA Dirigera hub.

Add it to your Gemfile or install it with gem install

# Quick start

Install it via rubygems:

```
gem install example
```

First, you need to get a token. Run the setup.rb from this repository to get it.

Then you can use the client:

```
require "dirigera"

client = Dirigera::Client.new(
  '192.168.x.x',
  'YOURTOKEN'
)

light = client.lights.last

light.name = 'Any light'

light.on
sleep 10
light.off

blinds = client.blinds.last

blinds.up
sleep 60
blinds.down
```

# TODO

- Yeah, I know, there is no specs...
- Scenes
- Link devices
- Set power loss behaviour
- Implement websocket to receive events
