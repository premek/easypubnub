-- example: 
-- local p = require('easypubnub')(publish_key, subscribe_key)
-- p.publish('lua-1', { text='hello there', time=os.date("%X")})
-- p.subscribe('lua-1', function(msg) print("CB:", msg.text) end )

local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson")

return function(publish_key, subscribe_key)

local p = {}

local host = "https://pubsub.pubnub.com/"




local encode = function(str)
  if str then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "%%20")
  end
  return str
end

local request = function(url)
  --print(url)
  local t = {}
  local r, c = http.request {
    url = url,
    sink = ltn12.sink.table(t),
    headers = {
      ['Content-Type'] = 'application/json; charset=UTF-8',
    },
    redirect = true
  }

  --print(c)
  --print(table.concat(t))
  --TODO if r==nil or c ~= 200 then return args.fail() end
  return json.decode(table.concat(t))
end

p.publish = function(channel, message)
  local url = host .. 'publish/' .. publish_key .. '/' .. subscribe_key 
    .. '/0/' .. encode(channel) .. '/0/' .. encode(json.encode(message))
  request(url)
end

p.subscribe = function(channel, cb)
  local url = host .. 'subscribe/' .. subscribe_key .. '/' .. encode(channel) .. '/0/'
  local timetoken, res
  timetoken = request(url..'0')[2]
  while true do
    res = request(url..timetoken)
    timetoken = res[2]
    for _, msg in ipairs(res[1]) do cb(msg) end
  end
end

return p
end
