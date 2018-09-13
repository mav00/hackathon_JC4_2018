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
  return t
end

--eingabe m_Fluchtplatz 0..500
--eingabe m_magicGefahr bool
--eingabe m_magicDistance 0..200
--eingabe m_GegnerStats_Speed {fast, med, slow}
--eingabe m_Gegner_CanBeHitByUs
-- eingabe m_Gegner_CanHitUs
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

function playerStrategie:doStrategie(me,enemy)

-- Wieviel Zeit hab ich
-- Angriff vs Verteidigung vs Flucht?
-- AngriffsArt/Verteidungsart/Fluchtart
-- IdealAbstand (zB Sicherheitsabstand oder Angriffsabstand)
-- ActionQueue updaten (add/clear/..)


end

return playerStrategie