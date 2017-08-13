# easypubnub.lua
A very simple interface to pubnub.com in lua.

Depends on `socket.http`, `dkjson`

Supports only publish/subscribe. Does not handle threads (sending / waiting on background), you have to do it yourself.


## love2d integration example
- enter your keys to `examples/love2d/cred.lua` file
- run two instances: `love examples/love2d/ & love examples/love2d/`
