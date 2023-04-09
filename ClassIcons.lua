--Filepath: /ClassIcons.lua

function getClassIcon(class)
    local classIcons = {
        ["WARRIOR"] = "Interface\\ICONS\\INV_Sword_04",
        ["PALADIN"] = "Interface\\ICONS\\INV_Hammer_01",
        ["HUNTER"] = "Interface\\ICONS\\INV_Weapon_Bow_07",
        ["ROGUE"] = "Interface\\ICONS\\INV_ThrowingKnife_04",
        ["PRIEST"] = "Interface\\ICONS\\INV_Staff_30",
        ["DEATHKNIGHT"] = "Interface\\ICONS\\Spell_Deathknight_ClassIcon",
        ["SHAMAN"] = "Interface\\ICONS\\INV_Jewelry_Talisman_04",
        ["MAGE"] = "Interface\\ICONS\\INV_Staff_13",
        ["WARLOCK"] = "Interface\\ICONS\\INV_Staff_30",
        ["MONK"] = "Interface\\ICONS\\INV_Staff_37",
        ["DRUID"] = "Interface\\ICONS\\INV_Misc_MonsterClaw_04",
        ["DEMONHUNTER"] = "Interface\\ICONS\\INV_Weapon_Glaive_01"
    }
    return classIcons[class]
end