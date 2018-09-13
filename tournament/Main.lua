require("Match")
require("Config")



console.writeline("--- COMBAT BEGIN ---")

Status.Setup()
ConfigLoader.LoadConfig()
local p1h = Loader.LoadFile("..\\Players\\standing.lua")
local p2h = Loader.LoadFile("..\\Players\\player1.lua")

local p1 = p1h.new(1)
local p2 = p2h.new(2)

Match.Fight(p1, p2) 

console.writeline("--- COMBAT  END ---")



