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
   t.lastActionString = "init"
  return t
end

--eingabe m_Fluchtplatz 0..500
--eingabe m_magicBullet bool
--eingabe m_magicBulletDistance 0..200
--eingabe m_GegnerStats_Speed {fast, med, slow}
--eingabe m_Gegner_CanBeHitByUs
--eingabe m_Gegner_CanHitUs
--eingabe m_ActivityEnemy
            -- spam
            -- block
            -- nichts
            -- jumper
            -- switcher
            -- ....

--schreibt m_actionQueue

-------------------------------------------------------
-- Wieviel Zeit hab ich
-- Angriff vs Verteidigung vs Flucht?
-- AngriffsArt/Verteidungsart/Fluchtart
-- IdealAbstand (zB Sicherheitsabstand oder Angriffsabstand)
-- ActionQueue updaten (add/clear/..)
function playerStrategie:doStrategie(me, enemy, input)
  self.me = me
  self.enemy = enemy
  self.input = input
  local enAttacking = (enemy["attacking"] == true)
  local meAttacking = (me["attacking"] == true)
  local enCrouching = (enemy["crounching"] == true)
  local magicBulletDanger = input.m_magicBullet
  local shouldApproach = input.m_Gegner_CanBeHitByUs
  local attackDistanceHigh = 90
  local attackDistanceMid = 74
  local attackDistanceLow = 80
  local blockDistance = 60
  local distToEnemy = me["distanceToOpponent"]
  local actionOngoing = false
 
  if actionOngoing then
    self:drawText(self.lastActionString)
    return
  end
  
  local r = "nix"
 
  if enAttacking and magicBulletDanger then
    self:actionDefendMagic()
    r = "defend magic"
  elseif enAttacking then
    if enCrouching and (distToEnemy < attackDistanceHigh) then
      r = "d crouch block"
    elseif (distToEnemy < blockDistance) then
      r = "d block"
    elseif (distToEnemy < attackDistanceLow) then
      r = "d punch light"
    elseif (distToEnemy < attackDistanceMid) then
      r = "d punch mid"
    elseif (distToEnemy < attackDistanceHigh) then
      r = "d block"
    else
      r = "air kick high"
    end
  else -- enemy not attacking
    if (distToEnemy < blockDistance) then
      r = "throw"
    elseif (distToEnemy < attackDistanceLow) then
      r = "punch light"
    elseif (distToEnemy < attackDistanceMid) then
      if enCrouching then
        r = "air kick high"
      else
        r = "punch mid"
      end
    else
      r = "rolling crystal flash"
    end
  end
  
  self.lastActionString = r .. " " .. distToEnemy
  self:drawText(self.lastActionString)
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
    Draw.DrawAtBottom(text)
  end
end



return playerStrategie
