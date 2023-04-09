local optionsPanelCreated = false

function createOptionsPanel()
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





function OnAddonLoadedAndPlayerLogout(self, event, ...)
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

