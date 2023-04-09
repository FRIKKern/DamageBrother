local frame = CreateFrame("Frame")
local damageFrame = CreateFrame("ScrollingMessageFrame", nil, UIParent)
local optionsPanelCreated = false
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
            return true, class
        end
    end
    return false
end


local function isPlayerInParty(playerName)
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
                _, _, spellTexture = GetSpellInfo(spellId)
            end
            local classIcon = getClassIcon(class)
            local damageText
            if amount and amount > 0 then
                if spellTexture then
                    damageText = string.format("|T%s:0|t |T%s:0|t %d", classIcon, spellTexture, amount)
                else
                    damageText = string.format("|T%s:0|t %d", classIcon, amount)
                end
            elseif missType then
                if spellTexture then
                    damageText = string.format("|T%s:0|t |T%s:0|t %s", classIcon, spellTexture, missType)
                else
                    damageText = string.format("|T%s:0|t %s", classIcon, missType)
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
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", OnCombatLogEvent)




local function createOptionsPanel()
    local optionsPanel = CreateFrame("Frame", "DamageBrotherOptionsPanel", UIParent)
    optionsPanel.name = "DamageBrother"

    local enableSoloCheckbox = CreateFrame("CheckButton", "DamageBrotherEnableSoloCheckbox", optionsPanel, "OptionsCheckButtonTemplate")
    enableSoloCheckbox:SetPoint("TOPLEFT", 16, -16)
    enableSoloCheckbox:SetScript("OnClick", function(self)
        local isChecked = self:GetChecked()
        if isChecked then
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            DamageBrotherDB.enableSolo = true
        else
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
            DamageBrotherDB.enableSolo = false
        end
    end)

    enableSoloCheckbox.text = enableSoloCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enableSoloCheckbox.text:SetPoint("LEFT", enableSoloCheckbox, "RIGHT", 0, 1)
    enableSoloCheckbox.text:SetText("Enable DamageBrother in Solo")

    function optionsPanel.refresh()
        enableSoloCheckbox:SetChecked(DamageBrotherDB.enableSolo)
    end

    optionsPanel.default = function()
        DamageBrotherDB.enableSolo = false
        enableSoloCheckbox:SetChecked(false)
    end

    InterfaceOptions_AddCategory(optionsPanel)
end





local function OnAddonLoadedAndPlayerLogout(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "DamageBrother" then
            DamageBrotherDB = DamageBrotherDB or { enabled = true, enableSolo = false }
            if not optionsPanelCreated then
                createOptionsPanel()
                optionsPanelCreated = true
            end
        end
    elseif event == "PLAYER_LOGOUT" then
        -- Save settings here if necessary
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