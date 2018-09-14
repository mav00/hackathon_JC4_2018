require("Player")

local _playerStrategie = require("playerStrategie")
local _playerinputs = require("playerinputs")
local _playerAction = require("playerAction")


local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}

function Example.new(player)
   local self = Player.new(player)
   setmetatable(self, Example_mt)

   self.m_playerAction = _playerAction.new(false)
   self.m_playerStrategy = _playerStrategie.new(self.m_playerAction,true)
   self.m_playerInputs = _playerinputs.new(false) 
   return self
end

function Example:startRound()
	self.m_playerInputs.startRound()
	self.m_playerAction.startRound()
	self.m_playerAction.startRound()

end

function Example:advance(me, enemy)

	local result = {}
	--calc_hitbox(me,enemy)
	x = enemy["fighter"]
	self.m_playerInputs:calc_Inputs(me,enemy)
    result = self.m_playerStrategy:doStrategie(me,enemy, self.m_playerInputs)
	return result

end

function Example:fighter()
	-- return "Ryu"
	-- return "Honda"
	-- return "Blanka"
	-- return "Guile"
	-- return "Balrog"
	-- return "Ken"
	-- return "ChunLi"
	-- return "Zangief"
	-- return "Dhalsim"
	-- return "Sagat"
	 return "Vega"
	-- return "THawk"
	-- return "Feilong"
	-- return "DeeJay"
	-- return "Cammy"
	-- return "MBison"
end

function Example:name()
	return "HaraldNukem"
end




return Example