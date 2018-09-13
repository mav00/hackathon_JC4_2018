local playerAction = {}

local throwDuration = 30
local throwDurationMid = 6
local throwDurationShort = 3

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
  result[self:backward(me)] = true
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

function playerAction:lowIntPunchKey() return "X" end
function playerAction:mediumIntPunchKey() return "Y" end
function playerAction:highIntPunchKey() return "Z" end

function playerAction:lowIntPunch()
 local result = {}
 result[self:lowIntPunchKey()] = true
 return result
end

function playerAction:mediumIntPunch()
 local result = {}
 result[self:mediumIntPunchKey()] = true
 return result
end

function playerAction:highIntPunch()
 local result = {}
 result[self:highIntPunchKey()] = true
 return result
end


-- punch and up/down move
function playerAction:lowPunch(intensity)
    local result = {}
    if intensity == "L" then 
      result[self:lowIntPunchKey()] = true
    end
    if intensity == "M" then 
      result[self:mediumIntPunchKey()] = true
    end
    if intensity == "H" then 
      result[self:highIntPunchKey()] = true
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
      return result
   end

   self.i = self.i + 1
   return result
end

function playerAction:jumpPunch(me)
   local result = {}
   if self.i > 9 then
     result[self:lowIntPunchKey()] = true
   end
   
   if self.i < 30 then  -- up
      result["Up"] = true
  end
  
  if self.i > 30 and (me["y"] < 1) then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- medium intensity rainbow
function playerAction:rainbowM(me)
   local result = {}
   if self.i <= throwDurationShort then  -- back
      result[self:forward(me)] = true
   elseif self.i > throwDurationShort and self.i < throwDuration
   then -- back + punch
      result[self:forward(me)] = true
      result[self:mediumIntPunchKey()] = true
   elseif self.i > throwDuration
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- medium intensity stardust drop
function playerAction:stardustDropM(me)
   local result = {}
   if self.i < throwDurationShort then 
      result[self:forward(me)] = true
      result["Up"]=true
   end
   if self.i < 6 then  -- back
      result[self:forward(me)] = true
   elseif self.i > 6 and self.i < throwDuration
   then -- back + punch
      result[self:backward(me)] = true
      result[self:mediumIntPunchKey()] = true
   elseif self.i > throwDuration
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- high intensity rainbow
function playerAction:rainbowH(me)
   local result = {}
   if self.i < throwDurationShort then  -- back
      result[self:backward(me)] = true
   elseif self.i > throwDurationShort and self.i < throwDuration
   then -- back + punch
      result[self:backward(me)] = true
      result[self:highIntPunchKey()] = true
   elseif self.i > throwDuration
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- high intensity stardust drop
function playerAction:stardustDropH(me)
   local result = {}
   if self.i < throwDurationShort then 
      result[self:forward(me)] = true
      result["Up"]=true
   end
   if self.i < 6 then  -- back
      result[self:forward(me)] = true
   elseif self.i > 6 and self.i < throwDuration
   then -- back + punch
      result[self:backward(me)] = true
      result[self:highIntPunchKey()] = true
   elseif self.i > throwDuration
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- royal christal flash
function playerAction:royalChristalFlash(me)
   local result = {}
   if self.i < 80 then 
      result[self:backward(me)] = true
   elseif self.i > 80 and self.i < 120
   then -- up + punch
      result[self:forward(me)] = true
      result[self:highIntPunchKey()] = true
   elseif self.i > 120
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end

-- sky high claw
function playerAction:skyHighClaw(me)
   local result = {}
   if self.i < 150 then 
      result["Down"] = true
   elseif self.i > 150 and self.i < 170
   then -- up + punch
      result["Up"] = true
      result[self:highIntPunchKey()] = true
   elseif self.i > 170
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end



--[[ KICKS ]]-- 
function playerAction:lowIntKickKey() return "A" end
function playerAction:mediumIntKickKey() return "B" end
function playerAction:highIntKickKey() return "C" end

function playerAction:lowIntKick()
 local result = {}
 result[self:lowIntKickKey()] = true
 return result
end

function playerAction:mediumIntKick() 
 local result = {}
 result[self:mediumIntKickKey()] = true
 return result
end

function playerAction:highIntKick() 
 local result = {}
 result[self:highIntKickKey()] = true
 return result
end

-- punch and up/down move
function playerAction:lowKick(intensity)
    local result = {}
    if intensity == "L" then 
      result[self:lowIntKickKey()] = true
    end
    if intensity == "M" then 
      result[self:mediumIntKickKey()] = true
    end
    if intensity == "H" then 
      result[self:highIntKickKey()] = true
    end
    result["Down"] = true
    return result
end

function playerAction:airKick(me)
   local result = {}
   if self.i < 40 then  -- up
      result["Up"] = true
      result[self:forward(me)] = true
   elseif self.i > 40 and self.i < 44
   then -- MP
      result["C"] = true
   elseif self.i >50
   then
      self.i = 0
      return result
   end

   self.i = self.i + 1
   return result
end



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
 return self.i > 0
end

return playerAction