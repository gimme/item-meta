-- Starting codepoint: \243\180\191\128 = U+F4FC0 = 1003456
local id = 127
--- Returns the next unicode in the custom font range.
local function NextCode()
    id = id + 1
    assert(id <= 191, "Out of range")
    return string.char(243) .. string.char(180) .. string.char(191) .. string.char(id)
end

return {
    -- Icons from the custom font
    ARMOR = NextCode(),
    DAMAGE = NextCode(),
    DISCHARGE = NextCode(),
    DURABILITY = NextCode(),
    FREEZE = NextCode(),
    FUEL = NextCode(),
    HEALTH = NextCode(),
    HUNGER = NextCode(),
    OVERHEAT = NextCode(),
    ROTTING = NextCode(),
    SANITY = NextCode(),
    SANITY_RESTORE = NextCode(),
    WEARING = NextCode(),
    WETNESS = NextCode(),

    -- Emojis from the game
    EMOJI_DAMAGE = "\238\128\152", -- "󰀘"
    EMOJI_HEALTH = "\238\128\141", -- "󰀍"
    EMOJI_HUNGER = "\238\128\142", -- "󰀎"
    EMOJI_SANITY = "\238\128\147", -- "󰀓"
}
