
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


m_MeLeft = 0
m_MeRight = 10

function calcBoundingBoxes(me, enemy)
    --me
    if me["facingRight"] then
        m_MeNose = me["x"]  
        m_MeBack =  m_MeNose - 10
        m_MeReach = m_MeNose + 15
	else
        m_MeBack =  me["x"]
        m_MeNose = meBack - 10 
        m_MeReach = m_MeNose - 15

    end

    --enemy
    if enemy["facingRight"] then
        m_EnemyNose = enemy["x"]  
        m_EnemyBack =  m_EnemyNose - 10       -- TODO: enemy specific
        m_EnemyReach = m_EnemyNose + 15       -- how far would the (longest non-magical body part) reach  TODO: Enemy specific
	else
        m_EnemyBack =  enemy["x"]
        m_EnemyNose = EnemyBack - 10          -- TODO: enemy specific
        m_EnemyReach = m_EnemyNose - 15       -- TODO: enemy specific
    end
end




function calc_Inputs(me, enemy)

    -- prep stuff
    calcBoundingBoxes(me, enemy)
    local bFacingRight = me["facingRight"]


    --Fluchtplatz
    if bFacingRight then
        me.m_Fluchtplatz = m_MeBack     --space behind me on the left
    else
        me.m_Fluchtplatz = 500 - m_MeBack   --spece behind me on the right
    end

    --distance to magic
    m_magicGefahr = enemy["magic"]
    if(m_magicGefahr) then
        m_magicDistance = math.abs(enemy["remoteAttackPos"] - m_MeNose)
    end

    --enemy speed
    -- TODO: enemy specific
    local enemyname = enemy["fighter"]
    if enemyname == "Ryu" then
        m_Gegner_Speed = fast
    elseif enemyname == "Honda" then
        m_Gegner_Speed = fast
    else
        m_Gegner_Speed = fast
    end

    --bedrohung
    if bFacingRight then
        m_Gegner_CanHitUs = m_EnemyReach < m_MeNose
    else
        m_Gegner_CanHitUs = m_EnemyReach > m_MeNose
    end

    --chancen
    if bFacingRight then
        m_Gegner_CanBeHitByUs =  m_MeReach > m_EnemyNose 
    else
        m_Gegner_CanBeHitByUs = m_MeReach < m_EnemyNose
    end

    --enemy strategy/attitude/activity based on character and long term observation
    

end
