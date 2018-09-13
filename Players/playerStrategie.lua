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


oInit, dCrouchBlock, dBlock, dKickLow, dPunchLow, dAirKickHigh = "o init", "d crouch block", "d block", "d kick low", "d punch low", "d air kick high"
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
  local attackDistanceSlide = 104
  local attackDistancePHigh = 79
  local attackDistancePMid = 74
  local attackDistancePLow = 45
  local attackDistanceKHigh = 50
  local attackDistanceKMid = 61
  local attackDistanceKLow = 41
  local attackDistanceThrow = 40
  local blockDistance = 35
  local distToEnemy = me["distanceToOpponent"]
  local actionOngoing = self.action:isInAction()
 
  if actionOngoing then
    self:drawText(self.lastAction .. "~")
    return getActionResult(self.lastAction)
  end
  
  local r = oInit
 
  if enAttacking and magicBulletDanger then
    r = "defend magic"
    a = self:actionDefendMagic()
  elseif enAttacking then
    if enCrouching and (distToEnemy < attackDistancePHigh) then
      r = dCrouchBlock
    elseif (distToEnemy < blockDistance) then
      r = dBlock
    elseif (distToEnemy < attackDistanceKLow) then
      r = dKickLow
    elseif (distToEnemy < attackDistancePLow) then
      r = dPunchLow
    elseif (distToEnemy < attackDistancePHigh) then
      r = dBlock
    else
      r = dAirKickHigh
    end
  else -- enemy not attacking
    if (distToEnemy < attackDistanceThrow) then
      r = "throw"
    elseif (distToEnemy < attackDistancePLow) then
      r = "punch light"
    elseif (distToEnemy < attackDistancePMid) then
      if enCrouching then
        r = "air kick high"
      else
        r = "punch mid"
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
  if dCrouchBlock then
    r = self.action:goBackward(self.me)
    r["Down"] = true
  elseif dBlock then
    r = self.action:goBackward(self.me)
  elseif dKickLow then
    r = self.action:kick("L")
  elseif dPunchLow then
    r = self.action:punch("L")
  elseif dAirKickHigh then
    r = self.action:airPunch(me)
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
    Draw.DrawAtBottom(text .. " " .. self.me["distanceToOpponent"])
  end
end



return playerStrategie
