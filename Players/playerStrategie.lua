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
   t.lastAction = oInit
   t.airTopReached = false
   t.eyold = 0
   t.actionDelay = 0
   t.dizzyThrows = 2
   t.dizzyWait = 0
   t.forwardSteps = 0
   t.lastDistToEnemy = 0
   t.firstBlood = false
   t.approachSteps = 0
  return t
end

function playerStrategie:startRound()
  self.lastAction = oInit
  self.airTopReached = false
  self.eyold = 0
  self.actionDelay = 0
  self.dizzyThrows = 2
  self.dizzyWait = 0
  self.forwardSteps = 0
  self.lastDistToEnemy = 0
  self.firstBlood = false
  self.approachSteps = 0
end



oInit, dCrouchBlock, dBlock, dKickLow, dPunchLow, dPunchMid, dPunchHigh, dSlide, dAirKickHigh,
punchLow, punchMid, punchHigh, airKickHigh, crouchPunchHigh, vertPunchLow, rainbowMid, skyHighClaw, slide,
goBackward, goForward =
"o init", "d crouch block", "d block", "d kick low", "d punch low", "d punch mid", "d punch high", "d slide", "d air kick high",
"punch low", "punch mid", "punch high", "air kick high", "crouch punch high", "vert punch low", "rainbow mid", "skyHighClaw", "slide",
"go backward", "go forward"
-------------------------------------------------------
function playerStrategie:doStrategie(me, enemy, input)
  self.me = me
  self.enemy = enemy
  self.input = input
  local ey = enemy["y"]
  local enAttacking = (enemy["attacking"] == true)
  local meAttacking = (me["attacking"] == true)
  local enCrouching = (enemy["crounching"] == true)
  local enBacking = (enemy["goingBack"] == true)
  local eitherApproach = (me["advancing"] or enemy["advancing"])
  if eitherApproach then self.approachSteps = self.approachSteps + 1 else self.approachSteps = 0 end
  local magicBulletDanger = input.m_magicBullet
  local shouldApproach = input.m_Gegner_CanBeHitByUs
  local airTop = 25
  local attackDistanceSlide = 110
  local attackDistancePHigh = 98
  local attackDistancePMid = 91
  local attackDistancePLow = 57
  local attackDistanceKHigh = 63
  local attackDistanceKMid = 74
  local attackDistanceKLow = 54
  local attackDistanceThrow = 25
  local blockDistance = 80
  if enBacking then
    attackDistancePMid = attackDistancePMid - 5
  end
  local distToEnemy = input.m_Gegner_DistanceNose2Nose
  local deltaDistToEnemy = (distToEnemy - self.lastDistToEnemy)
  if enemy["blockOrHit"] then self.firstBlood = true end
  if not input.m_GegnerImpaired then
    self.dizzyThrows = 2
    self.dizzyWait = 0
  end
  
  local enJumping = (ey > 1)
  local enFalling = (ey - self.eyold < 0)
  if ey > airTop then
    self.airTopReached = true
  elseif ey < 1 then
    self.airTopReached = false
  end
  self.eyold = ey
  
  local actionOngoing = self.action:isInAction()
  if actionOngoing then
    self:drawText(self.lastAction .. "~")
    return self:getActionResult(self.lastAction)
  elseif (self.actionDelay > 0) then
    self.actionDelay = self.actionDelay - 1
    self:drawText("wait")
    return {}
  end
  
  local r = oInit
 
  if enAttacking and magicBulletDanger then
    r = self:actionDefendMagic()
  elseif input.m_GegnerImpaired then
    if (self.dizzyWait > 0) then
      self.dizzyWait = self.dizzyWait - 1
      r = oInit
    elseif (self.dizzyThrows > 0) then
      if (distToEnemy > attackDistanceThrow) then
        r = goForward
      else
        r = rainbowMid
        self.dizzyThrows = self.dizzyThrows - 1
      end
    elseif (distToEnemy > attackDistancePMid) then
      r = goForward
    else
      r = punchMid
    end
  elseif enJumping then
    --[[if self.airTopReached and (distToEnemy < attackDistancePLow) and not enFalling then
      r = vertPunchLow
    elseif self.airTopReached then
      r = dCrouchBlock--crouchPunchHigh
    else
      r = goBackward
    end]]--
    r = dSlide
  elseif enAttacking then
    if enCrouching and input.m_Gegner_CanHitUs then
      r = dAirKickHigh
    elseif input.m_Gegner_CanHitUs then
      r = dCrouchBlock
    elseif (distToEnemy < attackDistanceSlide) then
      r = dSlide
    else
      -- chill
    end
  else -- enemy not attacking
    if enCrouching then
      if (distToEnemy < attackDistancePLow) then
        r = vertPunchLow
      elseif (distToEnemy < attackDistanceSlide) then
        r = slide --airKickHigh
      else
        r = goForward
      end
    elseif (distToEnemy < attackDistanceThrow) then
      r = rainbowMid
    elseif (distToEnemy < attackDistancePLow) then
      r = slide
    elseif (distToEnemy < attackDistancePMid) then
      r = punchMid
    elseif (distToEnemy < (attackDistancePMid + 10)) and (((not firstBlood and (self.forwardSteps > 2))) or (self.approachSteps > 8)) then
      r = punchMid
    elseif (distToEnemy < attackDistancePHigh) then
      r = punchHigh
    else
      r = goForward
    end
  end
  
  --[[if (r == self.lastAction) and (self.actionDelay > 0) then
    self.actionDelay = self.actionDelay - 1
    self:drawText(self.lastAction .. "o")
    return {}
  end]]--
  self.lastAction = r
  self:drawText(self.lastAction)
  return self:getActionResult(self.lastAction)
end

function playerStrategie:getActionResult(a)
  r = {}
  local forward = false
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
  elseif dSlide == a then
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
  elseif crouchPunchHigh == a then
    r = self.action:lowPunch("H")
  elseif rainbowMid == a then
    r = self.action:rainbowM(self.me)
  elseif vertPunchLow == a then
    r = self.action:jumpPunch(self.me, self.enemy)
  elseif skyHighClaw == a then
    r = self.action:skyHighClaw(self.me)
  elseif slide == a then
    r = self.action:lowKick("H")
  elseif goBackward == a then
    r = self.action:goBackward(self.me)
  elseif goForward == a then
    r = self.action:goForward(self.me)
    forward = true
  end
  
  if forward then
    self.forwardSteps = self.forwardSteps + 1
  else
    self.forwardSteps = 0
  end
  
  return r
end

function playerStrategie:actionDefendMagic()
  local bulletDistance = self.input.m_magicBulletDistance
  
  if bulletDistance > 60 then 
    return goBackward
  elseif bulletDistance < 50 then 
    return goBackward
  else
    return airKickHigh
  end
end

function playerStrategie:drawText(text)
  if (self.debug and (text ~= nil)) then
    local face = "L"
    if self.me["facingRight"] then
      face = "R"
    end
    Draw.DrawAtBottom(text .. " " .. self.input.m_Gegner_DistanceNose2Nose .. " " .. face .. " y:" .. self.enemy["y"])
  end
end



return playerStrategie
