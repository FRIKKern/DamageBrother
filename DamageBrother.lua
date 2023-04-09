print("DamageBrother loaded")

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




local function OnCombatLogEvent(self, event, ...)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14, arg15, arg16 = CombatLogGetCurrentEventInfo()

    if eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "SPELL_BUILDING_DAMAGE" or eventType == "RANGE_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "ENVIRONMENTAL_DAMAGE" or eventType == "SWING_MISSED" or eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
        local isPartyMember, class = isPlayerInParty(sourceName)
        if isPartyMember or DamageBrotherDB.enableSolo then
            local amount, missType, spellId, spellTexture
            if eventType == "SWING_DAMAGE" or eventType == "ENVIRONMENTAL_DAMAGE" then
                amount = arg12
            elseif eventType == "SWING_MISSED" then
                missType = arg12
            elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "SPELL_BUILDING_DAMAGE" or eventType == "RANGE_DAMAGE" then
                spellId = arg12
                amount = arg15
            elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
                spellId = arg12
                missType = arg16
            end
            if spellId then
                _, _, spellTexture = GetSpellTexture(spellId)
            end
            local classIcon = getClassIcon(class)
            local classColor = getClassColor(class)
            local damageText
            if amount and amount > 0 then
                if spellTexture then
                    damageText = string.format("|T%s:0|t |T%s:0|t |cff%02x%02x%02x%d|r", classIcon, spellTexture, classColor.r * 255, classColor.g * 255, classColor.b * 255, amount)
                else
                    damageText = string.format("|T%s:0|t |cff%02x%02x%02x%d|r", classIcon, classColor.r * 255, classColor.g * 255, classColor.b * 255, amount)
                end
            elseif missType then
                if spellTexture then
                    damageText = string.format("|T%s:0|t |T%s:0|t |cff%02x%02x%02x%s|r", classIcon, spellTexture, classColor.r * 255, classColor.g * 255, classColor.b * 255, missType)
                else
                    damageText = string.format("|T%s:0|t |cff%02x%02x%02x%s|r", classIcon, classColor.r * 255, classColor.g * 255, classColor.b * 255, missType)
                end
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

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


frame:SetScript("OnEvent", function(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        OnCombatLogEvent(self, event, ...)
    else
        OnAddonLoadedAndPlayerLogout(self, event, ...)
    end
end)



local function onCombatLogEventUnfiltered(event, ...)
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
    if eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "RANGE_DAMAGE" then
        local spellId, spellName, spellSchool, baseAmount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)
        local unitLevel = UnitLevel(destName) or 0 -- Get the level of the target, or assume level 0 if unknown
        local amount = baseAmount + (unitLevel - 1) * 5 + 10 -- Calculate the damage amount based on level
        local damageColor = "|cff00ff00" -- Green
        if amount < 1000 then
            damageColor = "|cffffff00" -- Yellow
        elseif amount > 10000 then
            damageColor = "|cffff0000" -- Red
        end
        local targetFrame = TargetFrameToT
        targetFrame.healthbar.dmgtext:SetTextColor(GameTooltip_UnitColor(targetFrame.unit))
        targetFrame.healthbar.dmgtext:SetText(damageColor..amount.."|r")
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", onCombatLogEventUnfiltered)










local function GetClassColor(classFileName)
    local color = RAID_CLASS_COLORS[classFileName]
    return color.r, color.g, color.b
end

local function UpdateFCTColor()
    local _, classFileName = UnitClass("player")
    local r, g, b = GetClassColor(classFileName)

    -- Set the color for floatingCombatTextCombatDamage
    DAMAGE_TEXT_FONT:SetTextColor(r, g, b)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        UpdateFCTColor()
    end
end)