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

   self.i = 0 
   self.m_playerAction = _playerAction.new()
   self.m_playerStrategy = _playerStrategie.new(self.m_playerAction)
   self.m_playerInputs = _playerinputs.new() 
   

   return self
end

function Example:forward(me)
	if me["facingRight"] then
		return "Right"
	end
	return "Left"
end

function Example:backward(me)
	if me["facingRight"] then
		return "Left"
	end
	return "Right"
end

function Example:distanceToMagic(me, enemy)
	if me["facingRight"] then
		return  me["x"] - enemy["remoteAttackPos"]
	else
		return enemy["remoteAttackPos"] - me["x"]
	end
end


function Example:advance(me, enemy)

	local result = {}
	--calc_hitbox(me,enemy)
	x = enemy["fighter"]
	self.m_playerInputs:calc_Inputs(me,enemy)
	self.m_playerStrategy:doStrategie(me,enemy, self.m_playerInputs)


	

	

	--if me["attacking"] == true then
	

	
		--if enemy["attaking"] then 
		--	if enemy["magic"] and enemy["remoteAttack"] then
		

	
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
	return "space Worf"
end




return Example