-- Disable with incompatible mods
local CHECK_MODS = {
    "workshop-347079953", -- Display Food Values
}
for _, modName in ipairs(CHECK_MODS) do if GLOBAL.KnownModIndex:IsModEnabled(modName) then return end end
for _, modName in pairs(GLOBAL.KnownModIndex:GetModsToLoad()) do if CHECK_MODS[modName] then return end end

-- IMPORTS
local pcall = GLOBAL.pcall
local require = GLOBAL.require
local TheSim = GLOBAL.TheSim
local resolvefilepath = GLOBAL.resolvefilepath
local LoadFonts = GLOBAL.LoadFonts
local DEFAULT_FALLBACK_TABLE = GLOBAL.DEFAULT_FALLBACK_TABLE
local DEFAULT_FALLBACK_TABLE_OUTLINE = GLOBAL.DEFAULT_FALLBACK_TABLE_OUTLINE
local FONTS = GLOBAL.FONTS
local mod_interface = require("itemmeta.mod_interface")
local ItemTile = require("widgets/itemtile")
local Inv = require("widgets/inventorybar")
local HoverText = require("widgets/hoverer")

-- ASSETS
local ICONS_FONT_ALIAS = "itemmeta_icons"
local ICONS_FONT_PATH = resolvefilepath("fonts/icons.zip")

-- Declare the font asset in the mod asset table
Assets = {
    Asset("FONT", ICONS_FONT_PATH),
}

-- Load the icons font
AddSimPostInit(function()
    -- Add icons to the list of fonts to load
    table.insert(FONTS, { filename = ICONS_FONT_PATH, alias = ICONS_FONT_ALIAS, disable_color = true })

    -- Add icons (as fallback) to other fonts
    table.insert(DEFAULT_FALLBACK_TABLE, 1, ICONS_FONT_ALIAS)
    table.insert(DEFAULT_FALLBACK_TABLE_OUTLINE, 1, ICONS_FONT_ALIAS)

    -- Reload all fonts
    LoadFonts()
end)

-- CONFIG
GLOBAL.MOD_ITEMMETA = {
    FoodFormat = GetModConfigData("FOOD_FORMAT"),
}

-- Add metadata to inventory item tooltips
local _ItemTile_GetDescriptionString = ItemTile.GetDescriptionString
function ItemTile:GetDescriptionString()
    local success, result = pcall(mod_interface.GetItemMetaDescription, self.item)
    return _ItemTile_GetDescriptionString(self) .. (success and result or "")
end

-- Add metadata to inventory item tooltips (controller mode)
local _Inv_GetDescriptionString = Inv.GetDescriptionString
function Inv:GetDescriptionString(item)
    local success, result = pcall(mod_interface.GetItemMetaDescription, item)
    return _Inv_GetDescriptionString(self, item) .. (success and result or "")
end

-- Adjust the tooltip position to keep it on screen. Only change is the YOFFSETDOWN value.
function HoverText:UpdatePosition(x, y)
    local scale = self:GetScale()
    local scr_w, scr_h = TheSim:GetScreenSize()
    local w = 0
    local h = 0

    if self.text ~= nil and self.str ~= nil then
        local w0, h0 = self.text:GetRegionSize()
        w = math.max(w, w0)
        h = math.max(h, h0)
    end
    if self.secondarytext ~= nil and self.secondarystr ~= nil then
        local w1, h1 = self.secondarytext:GetRegionSize()
        w = math.max(w, w1)
        h = math.max(h, h1)
    end

    w = w * scale.x * .5
    h = h * scale.y * .5

    local YOFFSETUP = -80
    local YOFFSETDOWN = 0 -- Changed from -50
    local XOFFSET = 10

    self:SetPosition(
            math.clamp(x, w + XOFFSET, scr_w - w - XOFFSET),
            math.clamp(y, h + YOFFSETDOWN * scale.y, scr_h - h - YOFFSETUP * scale.y),
            0)
end
