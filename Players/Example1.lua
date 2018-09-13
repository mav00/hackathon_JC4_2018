require("Player")

local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}

function Example.new(player)
   local self = Player.new(player)
   setmetatable(self, Example_mt)
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

function Example:startRound()
   self.i = 0 
end

function Example:advance(me, enemy)
	if me["attacking"] == true or me["remoteAttack"] == true then
		if self.i ~= 0 then 
			self.i = 0
		end
		return {}
	end

	if self.i > 80 then 
		-- The Hadoken could not be completed (we were hit, enemy was too close, etc.) 
		self.i = 0
	end

	return self:Hadoken(me) 
end

function Example:fighter()
	return "Ryu"
	-- return "Honda"
	-- return "Blanka"
	-- return "Guile"
	-- return "Balrog"
	-- return "Ken"
	-- return "ChunLi"
	-- return "Zangief"
	-- return "Dhalsim"
	-- return "Sagat"
	-- return "Vega"
	-- return "THawk"
	-- return "Feilong"
	-- return "DeeJay"
	-- return "Cammy"
	-- return "MBison"
end

function Example:name()
	return "Example1"
end

function Example:Hadoken(me)
   local result = {}
   local forward = self:forward(me)
   if self.i < 2 then  -- forward
      result["Down"] = true
   elseif self.i < 4 then -- down + forward
      result["Down"] = true
	  result[forward] = true
   elseif self.i < 6 then -- forward
	  result[forward] = true
   elseif self.i < 8 then -- forward + punch
      result[forward] = true
      result["Y"] = true  
   end
   self.i = self.i + 1
   return result
end

return Example