--require("foo")
--local obj = foo:new()
local f = require "fobo"
local ifobo = f.new(42)
ifobo:foo()