function getClassColor(class)
    local colors = {
        ["DEATHKNIGHT"] = {r = 0.77, g = 0.12, b = 0.23},
        ["DEMONHUNTER"] = {r = 0.64, g = 0.19, b = 0.79},
        ["DRUID"]       = {r = 1.00, g = 0.49, b = 0.04},
        ["HUNTER"]      = {r = 0.67, g = 0.83, b = 0.45},
        ["MAGE"]        = {r = 0.25, g = 0.78, b = 0.92},
        ["MONK"]        = {r = 0.00, g = 1.00, b = 0.59},
        ["PALADIN"]     = {r = 0.96, g = 0.55, b = 0.73},
        ["PRIEST"]      = {r = 1.00, g = 1.00, b = 1.00},
        ["ROGUE"]       = {r = 1.00, g = 0.96, b = 0.41},
        ["SHAMAN"]      = {r = 0.00, g = 0.44, b = 0.87},
        ["WARLOCK"]     = {r = 0.53, g = 0.53, b = 0.93},
        ["WARRIOR"]     = {r = 0.78, g = 0.61, b = 0.43}
    }
    return colors[class]
end

