-- Filepath: /DamageBrother.lua

local frame = CreateFrame("Frame")
local damageFrame = CreateFrame("ScrollingMessageFrame", nil, UIParent)
damageFrame:SetPoint("CENTER", 0, 100)
damageFrame:SetSize(400, 200)
damageFrame:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
damageFrame:SetMaxLines(10)
damageFrame:SetFading(true)
damageFrame:SetFadeDuration(2)
damageFrame:SetTimeVisible(5)
damageFrame:SetJustifyH("CENTER")

local function isPlayerInParty(playerName)
    for i = 1, GetNumGroupMembers() do
        local name, _, _, _, _, class = GetRaidRosterInfo(i)
        if playerName == name then
            print("Party member found:", playerName) -- Debug print
            return true, class
        end
    end
    return false
end

local function OnCombatLogEvent(self, event, ...)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14, arg15, arg16 = CombatLogGetCurrentEventInfo()

    if eventType == "SPELL_DAMAGE" or eventType == "SPæELL_PERIODIC_DAMAGE" or eventType == "SPELL_BUILDING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "ENVIRONMENTAL_DAMAGE" or eventType == "SWING_MISSED" or eventType == "SPELL_MISSED" or eventType == "RANGED_MISSED"  then
        local isPartyMember, class = isPlayerInParty(sourceName)
        if isPartyMember then
            local amount, missType
            if eventType == "SWING_DAMAGE" or eventType == "ENVIRONMENTAL_DAMAGE" then
                amount = arg12
            elseif eventType == "SWING_MISSED" then
                missType = arg12
            elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "SPELL_BUILDING_DAMAGE" or eventType == "RANGE_DAMAGE" then
                amount = arg15
            elseif eventType == "SPELL_MISSED" or eventType == "RANGED_MISSED" then
                missType = arg16
            end
            local classIcon = getClassIcon(class)
            local damageText
            if amount and amount > 0 then
                damageText = string.format("|T%s:0|t %d", classIcon, amount)
            elseif missType then
                damageText = string.format("|T%s:0|t %s", classIcon, missType)
            end
            if damageText then
                damageFrame:AddMessage(damageText, 0, 0, 1)
            end
        end

        -- Log the event type for all your damage events
        if sourceName == UnitName("player") then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("Event Type: %s", eventType))
        end
    end
end

frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", OnCombatLogEvent)