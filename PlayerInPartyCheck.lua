

function isPlayerInParty(playerName)
    if not IsInGroup() then
        if DamageBrotherDB.enableSolo and playerName == UnitName("player") then
            return true, select(2, UnitClass("player"))
        else
            return false
        end
    end

    for i = 1, GetNumGroupMembers() do
        local name, _, _, _, _, class = GetRaidRosterInfo(i)
        if playerName == name then
            return true, class
        end
    end
    return false
end


