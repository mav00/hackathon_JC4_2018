local playerInputs = {}

playerInputs.__index = playerInputs -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(playerInputs, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function playerInputs.new(init)
   local t = setmetatable({}, { __index = playerInputs })

   -- Your constructor stuff
   t.value = init
   t.m_MeBack = 0
   t.m_MeNose = 10
   t.m_MeReach = 25
   t.m_EnemyBack = 500
   t.m_EnemyNose = 490
   t.m_EnemyReach = 475
   t.m_Fluchtplatz = 10
   t.m_magicBullet = false
   t.m_magicBulletDistance = 200
   t.m_Gegner_Speed = fast
   t.m_Gegner_CanHitUs = true
   t.m_Gegner_CanBeHitByUs = false
   t.m_ActivityEnemy = switcher
  return t
end


--eingabe m_Fluchtplatz 0..500
--eingabe m_magicGefahr bool
--eingabe m_magicDistance 0..200
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



fast, med, slow = 0, 1, 2
sleeper, blocker, spammer, jumper, switcher = 0,1,2,3,4


function playerInputs:calcBoundingBoxes(me, enemy)
    --me
    if me["facingRight"] then
        self.m_MeNose = me["x"]  
        self.m_MeBack =  self.m_MeNose - 10
        self.m_MeReach = self.m_MeNose + 15
	else
        self.m_MeBack =  me["x"]
        self.m_MeNose = self.meBack - 10 
        self.m_MeReach = self.m_MeNose - 15

    end

    --enemy
    if enemy["facingRight"] then
        self.m_EnemyNose = enemy["x"]  
        self.m_EnemyBack =  self.m_EnemyNose - 10       -- TODO: enemy specific
        self.m_EnemyReach = self.m_EnemyNose + 15       -- how far would the (longest non-magical body part) reach  TODO: Enemy specific
	else
        self.m_EnemyBack =  enemy["x"]
        self.m_EnemyNose = self.EnemyBack - 10          -- TODO: enemy specific
        self.m_EnemyReach = self.m_EnemyNose - 15       -- TODO: enemy specific
    end
end




function playerInputs:calc_Inputs(me, enemy)

    -- prep stuff
    calcBoundingBoxes(me, enemy)
    local bFacingRight = me["facingRight"]
    local strEnemyName = enemy["fighter"]


    --Fluchtplatz
    if bFacingRight then
        self.m_Fluchtplatz = self.m_MeBack     --space behind me on the left
    else
        self.m_Fluchtplatz = 500 - self.m_MeBack   --spece behind me on the right
    end

    --distance to magic
    self.m_magicBullet = enemy["magic"] and enemy["remoteAttack"]
    if(self.m_magicBullet) then
        self.m_magicBulletDistance = math.abs(enemy["remoteAttackPos"] - self.m_MeNose)
    end

    --enemy speed
    -- TODO: enemy specific
    if strEnemyName == "Ryu" then
        self.m_Gegner_Speed = fast
    elseif strEnemyName == "Honda" then
        self.m_Gegner_Speed = fast
    else
        self.m_Gegner_Speed = fast
    end

    --bedrohung
    if bFacingRight then
        self.m_Gegner_CanHitUs = self.m_EnemyReach < self.m_MeNose
    else
        self.m_Gegner_CanHitUs = self.m_EnemyReach > self.m_MeNose
    end

    --chancen
    if bFacingRight then
        self.m_Gegner_CanBeHitByUs = self.m_MeReach > self.m_EnemyNose 
    else
        self.m_Gegner_CanBeHitByUs = self.m_MeReach < self.m_EnemyNose
    end

    --enemy strategy/attitude/activity based on character and long term observation
    -- TODO: enemy specific
    if strEnemyName == "Ryu" then
        self.m_ActivityEnemy = fast
    elseif strEnemyName == "Honda" then
        self.m_ActivityEnemy = fast
    else
        self.m_ActivityEnemy = switcher
    end

end
