local playerAction = {}

playerAction.__index = playerAction -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(playerAction, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function playerAction.new(init)
   local t = setmetatable({}, { __index = playerAction })

  t.i = 0
  return t
end

--[[
     MOVEMENT ACTIONS
]]--

-- go forward
function playerAction:goForward(me)
  local result = {}
  result[playerAction:forward(me)] = true
  return result
end

-- go backwards
function playerAction:goBackward(me)
  local result = {}
  result[backward(me)] = true
  return result
end

-- down / crunch
function playerAction:crunch(me)
  local result = {}
  result["Down"] = true
  return result
end

-- up/jump
function playerAction:jump(me)
  local result = {}
  result["Up"] = true
  return result
end

--[[ PUNCHES ]]-- 
function playerAction:lowIntPunch() return "X" end
function playerAction:mediumIntPunch() return "Y" end
function playerAction:highIntPunch() return "Z" end

-- punch and up/down move
function playerAction:lowPunch(intensity)
    local result = {}
    if intensity == "L" then 
      result[lowIntPunch] = true
    end
    if intensity == "M" then 
      result[mediumIntPunch] = true
    end
    if intensity == "H" then 
      result[highIntPunch] = true
    end
    result["Down"] = true
    return result
end
    
function playerAction:airPunch(me)
   local result = {}
   if self.i < 40 then  -- up
      result["Up"] = true
      result[self:forward(me)] = true
   elseif self.i > 40 and self.i < 44
   then -- MP
      result["Y"] = true
   elseif self.i >50
   then
      self.i = 0
   end

   self.i = self.i + 1
   return result
end


--[[ KICKS ]]-- 
function lowIntKick() return "A" end
function mediumIntKick() return "B" end
function highIntKick() return "C" end

-- punch and up/down move
function playerAction:lowKick(intensity)
    local result = {}
    if intensity == "L" then 
      result[lowIntKick] = true
    end
    if intensity == "M" then 
      result[mediumIntKick] = true
    end
    if intensity == "H" then 
      result[highIntKick] = true
    end
    result["Down"] = true
    return result
end


-- local functions

function playerAction:forward(me)
  if me["facingRight"] then
    return "Right"
  end
  return "Left"
end

function playerAction:backward(me)
  if me["facingRight"] then
    return "Left"
  end
  return "Right"
end

function playerAction:isInAction()
 return self.i == 0
end

return playerAction

