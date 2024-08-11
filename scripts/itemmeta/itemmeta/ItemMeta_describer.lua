local STRINGS = require("itemmeta.language.strings")
local ICONS = require("itemmeta.language.icons")
local debug = require("itemmeta.util.debug")

local describer = {}

--- Rounds the value to one decimal place.
---@param value number
---@return number
local function RoundToOneDecimal(value) return math.floor(value * 10 + 0.5) / 10 end

--- Returns a metadata entry for the description string, or an empty string if the value is nil.
---@param icon string
---@param value number
---@param format string|function
---@return string
local function CreateEntry(icon, value, format)
    if not value then return "" end
    debug.safecall(function()
        if type(value) == "number" then value = RoundToOneDecimal(value) end
        if type(format) == "function" then value = format(value) end
        if type(format) == "string" then value = value .. format end
    end)
    return icon .. " " .. value
end

--- Returns a metadata entry with a newline for the description string, or an empty string if the value is nil.
---@param icon string
---@param value number
---@param format string|function
---@return string The entry with a newline, or an empty string if the value is nil
local function CreateRow(icon, value, format)
    local entry = CreateEntry(icon, value, format)
    if entry and entry ~= "" then return "\n" .. entry else return "" end
end

--- Returns the description string for the normal metadata of the item.
---@param itemMeta ItemMeta The item metadata
---@return string
local function GetNormalDescription(itemMeta)
    local str = ""

    local function formatRestore(v) return (v >= 0 and "+" or "") .. v .. "/" .. STRINGS.MINUTE end
    local formatDamage = function(v)
        if itemMeta.prefab == "hambat" then
            local minDamage = RoundToOneDecimal(TUNING.HAMBAT_MIN_DAMAGE_MODIFIER * TUNING.HAMBAT_DAMAGE)
            return minDamage .. " - " .. v
        end
        return v
    end
    local insulationIcon = itemMeta.insulationType == SEASONS.SUMMER and ICONS.OVERHEAT or ICONS.FREEZE

    str = str .. CreateRow(ICONS.ARMOR, itemMeta.protection, "%")
    str = str .. CreateRow(ICONS.DAMAGE, itemMeta.damage, formatDamage)
    str = str .. CreateRow(ICONS.SANITY_RESTORE, itemMeta.sanityRestore, formatRestore)
    str = str .. CreateRow(ICONS.WETNESS, itemMeta.waterResist, "%")
    str = str .. CreateRow(insulationIcon, itemMeta.insulation)

    if itemMeta.consumable and (itemMeta.hunger or itemMeta.health or itemMeta.sanity) then
        local vertical = MOD_ITEMMETA.FoodFormat == "v"
        local suffix = vertical and "\n" or "  "

        str = str .. "\n"
        str = str .. CreateEntry(ICONS.HUNGER, itemMeta.hunger, suffix)
        str = str .. CreateEntry(ICONS.HEALTH, itemMeta.health, suffix)
        str = str .. CreateEntry(ICONS.SANITY, itemMeta.sanity, suffix)
        -- Remove the final suffix
        str = str:sub(1, -(1 + #suffix))
    end

    return str
end

--- Returns the description string for the alternate metadata of the item.
---@param itemMeta ItemMeta The item metadata
---@return string
local function GetAltDescription(itemMeta)
    local str = ""

    str = str .. CreateRow(ICONS.DURABILITY, itemMeta.uses, " " .. STRINGS.USES)
    str = str .. CreateRow(ICONS.WEARING, itemMeta.wearUses, " " .. STRINGS.USES)
    str = str .. CreateRow(ICONS.DURABILITY, itemMeta.hp, " " .. STRINGS.HP)
    str = str .. CreateRow(ICONS.ROTTING, itemMeta.perishTime, " " .. STRINGS.DAYS)
    str = str .. CreateRow(ICONS.WEARING, itemMeta.wearTime, " " .. STRINGS.DAYS)
    str = str .. CreateRow(ICONS.DISCHARGE, itemMeta.fuel, " " .. STRINGS.MINUTE)
    str = str .. CreateRow(ICONS.FUEL, itemMeta.fuelValue, " " .. STRINGS.SECOND)

    return str
end

--- Returns the description string for the metadata of the item.
---@param itemMeta ItemMeta The item metadata
---@param cooked boolean If the description is for the cooked version of the item
---@param alternate boolean If the alternate metadata should be shown
---@return string
function describer.GetDescription(itemMeta, cooked, alternate)
    local str = ""

    if alternate then
        str = str .. GetAltDescription(itemMeta)
    else
        str = str .. GetNormalDescription(itemMeta)
    end

    if cooked and str ~= "" then
        str = "\n" .. STRINGS.IF_COOKED .. str
    end

    return str
end

return describer
