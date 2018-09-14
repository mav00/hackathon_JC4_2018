
local playerInputs = {}

playerInputs.__index = playerInputs -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(playerInputs, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function playerInputs.new(a_bDebugOutAllowed)
   local t = setmetatable({}, { __index = playerInputs })

   -- Your constructor stuff
   -- init will be done in startRound()
  return t
end





fast, med, slow = 0, 1, 2
sleeper, blocker, spammer, jumper, switcher = 0,1,2,3,4

KEnemyName_Vega = "Vega"
KEnemyNme_Dhalsim = "Dhalsim"
KEnemyName_Honda = "Honda"


function playerInputs:startRound()
    self.PenaltyTime = 0
    self.bEnemyUsedMagic = false
    self.SpamMeasurement = {}
    for i = 1,300 do
        self.SpamMeasurement[i] = false
    end
    self.SpamMeasurementIndex = 1;
 
    self.m_bDebugOutAllowed = a_bDebugOutAllowed
    self.m_MeBack = 0
    self.m_MeNose = 10
    self.m_MeReach = 25
    self.m_EnemyBack = 500
    self.m_EnemyNose = 490
    self.m_EnemyReach = 475
    self.m_Fluchtplatz = 10
    self.m_magicBullet = false
    self.m_magicBulletDistance = 200
    self.m_Gegner_Speed = fast
    self.m_Gegner_CanHitUs = true
    self.m_Gegner_CanBeHitByUs = false
    self.m_Gegner_DistanceNose2Nose = 200
    self.m_ActivityEnemy = switcher
    self.m_GegnerImpaired = false
end


function playerInputs:calcBoundingBoxes(me, enemy)
    --me
    if me["facingRight"] then                   -- note: distancne values are for charatcer VEGA
        self.m_MeNose = me["x"]  
        self.m_MeBack =  self.m_MeNose - 10
        self.m_MeReach = self.m_MeNose + 90
	else
        self.m_MeBack =  me["x"]
        self.m_MeNose = self.m_MeBack - 10 
        self.m_MeReach = self.m_MeNose - 90

    end

    --enemy
    local strEnemyName = enemy["fighter"]
    local Dicke = 10        -- default
    local Schlagweite = 65  -- default
    if strEnemyName == KEnemyName_Vega then
        Schlagweite = 90
    elseif strEnemyName == KEnemyNme_Dhalsim then
        Schlagweite = 120
    elseif strEnemyName == KEnemyName_Honda then
        Dicke = 15
    end
    
    if enemy["facingRight"] then
        self.m_EnemyNose = enemy["x"]  
        self.m_EnemyBack =  self.m_EnemyNose - Dicke       -- TODO: enemy specific
        self.m_EnemyReach = self.m_EnemyNose + Schlagweite       -- how far would the (longest non-magical body part) reach  TODO: Enemy specific
	else
        self.m_EnemyBack =  enemy["x"]
        self.m_EnemyNose = self.m_EnemyBack - Dicke          -- TODO: enemy specific
        self.m_EnemyReach = self.m_EnemyNose - Schlagweite       -- TODO: enemy specific
    end
end




function playerInputs:calc_Inputs(me, enemy)

    -- prep stuff
    self:calcBoundingBoxes(me, enemy)
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
    ----dizziness und panelty ausnutzen
    if( enemy["magic"] ) then
        self.bEnemyUsedMagic = true
    else
        if self.bEnemyUsedMagic then
            self.bEnemyUsedMagic = false;
            self.PenaltyTime = 5
        end
    end
    if(self.PenaltyTime > 0) then
        self.PenaltyTime = self.PenaltyTime - 1
    end
    self.m_GegnerImpaired = enemy["dizzy"] or (self.PenaltyTime > 0)

    --- nose-to-nose distance to enemny
    self.m_Gegner_DistanceNose2Nose = math.abs( self.m_MeNose - self.m_EnemyNose )

    --enemy strategy/attitude/activity based on character and long term observation
    --- calc spamminess
    self.SpamMeasurement[self.SpamMeasurementIndex] = enemy["attacking"] or enemy["magic"] or enemy["attack"] or enemy["remoteAttack"]
    self.SpamMeasurementIndex = self.SpamMeasurementIndex + 1
    if self.SpamMeasurementIndex > 300 then
        self.SpamMeasurementIndex = 1
    end
    local SpamCount = 0
    for i=1,300 do
        if self.SpamMeasurement[i] then
            SpamCount = SpamCount + 1
        end
    end
    if SpamCount > 200 then
        self.m_ActivityEnemy = spammer
    elseif SpamCount < 10 then
        self.m_ActivityEnemy = sleeper
    else
        self.m_ActivityEnemy  = switcher
    end


    -- debugging
    if self.m_bDebugOutAllowed then
        local strGegnerCanHitUs = "";
        local strWeCanHitGegner ="";
        local strGegnerImpaired ="";
        local strGegnerActivity =""
        if(self.m_Gegner_CanHitUs) then
            strGegnerCanHitUs = "!"
        end
        if self.m_Gegner_CanBeHitByUs then
            strWeCanHitGegner = "!"
        end
        if self.m_GegnerImpaired then
            strGegnerImpaired = "X"..tostring(self.PenaltyTime)
        end
        local strMagicBulletDistance = ""
        if(self.m_magicBullet) then
            strMagicBulletDistance = "B: "..tostring(self.m_magicBulletDistance)..",   "
        end
        if(self.m_ActivityEnemy == spammer) then
            strGegnerActivity = "spam"
        elseif self.m_ActivityEnemy == sleeper then
            strGegnerActivity = "sleep"
        else
            strGegnerActivity = "switch"
        end

        Draw.DrawAtBottom(strMagicBulletDistance..strGegnerImpaired..strWeCanHitGegner.."E:"..strGegnerActivity..tostring(self.m_EnemyBack)..","..tostring(self.m_EnemyNose)..","..tostring(self.m_EnemyReach).."  "..strGegnerCanHitUs.."M: "..tostring(self.m_MeBack)..","..tostring(self.m_MeNose)..","..tostring(self.m_MeReach)..",d"..tostring(self.m_Gegner_DistanceNose2Nose))
    end


end

return playerInputs

