require("Player")

local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}

function Example.new(player)
   local self = Player.new(player)
   setmetatable(self, Example_mt)

   self.i = 0 

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
	if me["attacking"] == true then
		self.i = 0
		return {}
	end

	if self.i == 0 then
		if enemy["attaking"] then 
			if enemy["magic"] and enemy["remoteAttack"] then
				if self:distanceToMagic(me, enemy) > 60 then 
					return {}
				elseif self:distanceToMagic(me, enemy) < 50 then 
					return self:moveBackward(me)
				else
					return self:airPunch(me)
				end
			end  				
		else 
			if me["distanceToOpponent"] > 90 then
				return self:moveForward(me)
			elseif me["distanceToOpponent"] < 70 then
				return self:lowPunch(me)
			else 
				return self:airPunch(me) 
			end
		end 
	end

	if self.i > 80 then
		self.i = 0
	end 

	return self:airPunch(me)
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
	return "Dhalsim"
	-- return "Sagat"
	-- return "Vega"
	-- return "THawk"
	-- return "Feilong"
	-- return "DeeJay"
	-- return "Cammy"
	-- return "MBison"
end

function Example:name()
	return "Example2"
end

function Example:moveBackward(me)
   local result = {}
   result[self:backward(me)] = true
   return result
end

function Example:moveForward(me)
   local result = {}
   result[self:forward(me)] = true
   return result
end

function Example:lowPunch(me)
  local result = {}
  result["Down"] = true 
  result["Y"] = true 
  return result 
 end

function Example:airPunch(me)
   local result = {}
   if self.i < 40 then  -- up
      result["Up"] = true
	  result[self:forward(me)] = true
   elseif self.i > 40 and self.i < 44 then -- MP
	  result["Y"] = true
   end
   self.i = self.i + 1
   return result
end

return Example