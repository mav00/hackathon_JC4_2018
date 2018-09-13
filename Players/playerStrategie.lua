local playerStrategie = {}

playerStrategie.__index = playerStrategie -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(playerStrategie, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function playerStrategie.new(action, debugFlag)
   local t = setmetatable({}, { __index = playerStrategie })

   -- Your constructor stuff
   t.action = action
   t.debug = debugFlag
   t.isStrategyOffensive = true
   t.lastAction = oInit
  return t
end


oInit, dCrouchBlock, dBlock, dKickLow, dPunchLow, dPunchMid, dPunchHigh, dCrouchKickHigh, dAirKickHigh,
punchLow, punchMid, punchHigh, airKickHigh, rainbowMid =
"o init", "d crouch block", "d block", "d kick low", "d punch low", "d punch mid", "d punch high", "d crouch kick high", "d air kick high",
"punch low", "punch mid", "punch high", "air kick high", "rainbow mid"
-------------------------------------------------------
function playerStrategie:doStrategie(me, enemy, input)
  self.me = me
  self.enemy = enemy
  self.input = input
  local enAttacking = (enemy["attacking"] == true)
  local meAttacking = (me["attacking"] == true)
  local enCrouching = (enemy["crounching"] == true)
  local magicBulletDanger = input.m_magicBullet
  local shouldApproach = input.m_Gegner_CanBeHitByUs
  local attackDistanceSlide = 118
  local attackDistancePHigh = 99
  local attackDistancePMid = 93
  local attackDistancePLow = 58
  local attackDistanceKHigh = 63
  local attackDistanceKMid = 74
  local attackDistanceKLow = 54
  local attackDistanceThrow = 25
  local blockDistance = 80
  local distToEnemy = input.m_Gegner_DistanceNose2Nose
  local actionOngoing = self.action:isInAction()
 
  if actionOngoing then
    self:drawText(self.lastAction .. "~")
    return self:getActionResult(self.lastAction)
  end
  
  local r = oInit
 
  if enAttacking and magicBulletDanger then
    r = "defend magic"
    --a = self:actionDefendMagic()
  elseif enAttacking then
    if enCrouching and input.m_Gegner_CanHitUs then
      r = dAirKickHigh
    elseif input.m_Gegner_CanHitUs then
      r = dCrouchBlock
    elseif (distToEnemy < attackDistanceSlide) then
      r = dCrouchKickHigh -- slide
    else
      -- chill
    end
  else -- enemy not attacking
    if (distToEnemy < attackDistanceThrow) then
      r = rainbowMid
    elseif (distToEnemy < attackDistancePLow) then
      r = punchLow
    elseif (distToEnemy < attackDistancePMid) then
      if enCrouching then
        r = airKickHigh
      else
        r = punchMid
      end
    else
      r = "rolling crystal flash"
      
    end
  end
  
  self.lastAction = r
  self:drawText(self.lastAction)
  return self:getActionResult(self.lastAction)
end

function playerStrategie:getActionResult(a)
  r = {}
  if dCrouchBlock == a then
    r = self.action:goBackward(self.me)
    r["Down"] = true
  elseif dBlock == a then
    r = self.action:goBackward(self.me)
  elseif dKickLow == a then
    r = self.action:lowIntKick()
  elseif dPunchLow == a then
    r = self.action:lowIntPunch()
  elseif dPunchMid == a then
    r = self.action:mediumIntPunch()
  elseif dPunchHigh == a then
    r = self.action:highIntPunch()
  elseif dCrouchKickHigh == a then
    r = self.action:lowKick("H")
  elseif dAirKickHigh == a then
    r = self.action:airKick(self.me)
  elseif punchLow == a then
    r = self.action:lowIntPunch()
  elseif punchMid == a then
    r = self.action:mediumIntPunch()
  elseif punchHigh == a then
    r = self.action:highIntPunch()
  elseif airKickHigh == a then
    r = self.action:airKick(self.me)
  elseif rainbowMid == a then
    r = self.action:rainbowM(self.me)
  end
  return r
end

function playerStrategie:actionDefendMagic()
  local bulletDistance = self.input.m_magicBulletDistance
  
  if bulletDistance > 60 then 
    return {}
  elseif bulletDistance < 50 then 
    return self.action:goBackward(self.me)
  else
    return self.action:airPunch(self.me)
  end
end

function playerStrategie:drawText(text)
  if self.debug then
    Draw.DrawAtBottom(text .. " " .. self.input.m_Gegner_DistanceNose2Nose)
  end
end



return playerStrategie
