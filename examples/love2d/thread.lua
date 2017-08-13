local c = require 'cred'
local p = require('easypubnub')(c.publish_key, c.subscribe_key)
local threadChannel = love.thread.getChannel("pubnubthread")
p.subscribe(c.channel, function(msg) threadChannel:push(msg.text) end )


