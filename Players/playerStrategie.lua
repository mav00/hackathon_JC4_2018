local playerStrategie = {}

playerStrategie.__index = playerStrategie -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(playerStrategie, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function playerStrategie.new(init)
   local t = setmetatable({}, { __index = playerStrategie })

   -- Your constructor stuff
   t.value = init
   t.isStrategyOffensive = true
   t.actionOngoing = false
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

function playerStrategie:getValue()
  return self.value
end

-------------------------------------------------------
-- Wieviel Zeit hab ich
-- Angriff vs Verteidigung vs Flucht?
-- AngriffsArt/Verteidungsart/Fluchtart
-- IdealAbstand (zB Sicherheitsabstand oder Angriffsabstand)
-- ActionQueue updaten (add/clear/..)
function playerStrategie:doStrategie(me,enemy)
  self.me = me
  self.enemy = enemy
  local enAttacking = (enemy["attacking"] == true)
  local meAttacking = (me["attacking"] == true)
  local enCrouching = (enemy["crounching"] == true)
  local magicBulletDanger = (me["m_magicBullet"] == true)
  local shouldApproach = me["m_Gegner_CanBeHitByUs"]
  local attackDistanceHigh = 100
  local attackDistanceMid = 80
  local attackDistanceLow = 60
  local blockDistance = 50
  local distToEnemy = me["distanceToOpponent"]
 
  if actionOngoing then
    return
  end
 
  if enAttacking and magicBulletDanger then
    self:actionDefendMagic()
  elseif enAttacking then
    if enCrouching and (distToEnemy < attackDistanceHigh) then
      -- crouch block
    elseif (distToEnemy < blockDistance) then
      -- block
    elseif (distToEnemy < attackDistanceLow) then
      -- punch light
    elseif (distToEnemy < attackDistanceMid) then
      -- punch mid
    elseif (distToEnemy < attackDistanceHigh) then
      -- crouch kick high
    else
      -- air kick
    end
  else -- enemy not attacking
    if (distToEnemy < blockDistance) then
      -- throw
    elseif (distToEnemy < attackDistanceLow) then
      -- kick light
    elseif (distToEnemy < attackDistanceHigh) then
      -- kick high
    else
      -- rolling crystal flash
    end
  end
  
end

function playerStrategie:actionDefendMagic()
  local bulletDistance = self.me["m_magicBulletDistance"]
  
  if bulletDistance > 60 then 
    return {}
  elseif bulletDistance < 50 then 
    return self:moveBackward(self.me)
  else
    return self:airPunch(self.me)
  end
end



return playerStrategie
