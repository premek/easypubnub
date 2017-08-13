local c = require 'cred'
local p = require('../../easypubnub')(c.publish_key, c.subscribe_key)

local text = 'start typing\n'
local thread = love.thread.newThread("thread.lua")
local channel = love.thread.getChannel("pubnubthread")
thread:start()

function love.update(dt)
  v = channel:pop()
  if v then text = text..v end
end

function love.draw()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print(text, 10, 20)
end

function love.keypressed(key)
  p.publish(c.channel, {text=key})
end

