-- Disable with incompatible mods
local CHECK_MODS = {
    "workshop-347079953", -- Display Food Values
}
for _, modName in ipairs(CHECK_MODS) do if GLOBAL.KnownModIndex:IsModEnabled(modName) then return end end
for _, modName in pairs(GLOBAL.KnownModIndex:GetModsToLoad()) do if CHECK_MODS[modName] then return end end

-- IMPORTS
local pcall = GLOBAL.pcall
local require = GLOBAL.require
local resolvefilepath = GLOBAL.resolvefilepath
local LoadFonts = GLOBAL.LoadFonts
local Vector3 = GLOBAL.Vector3
local TheInput = GLOBAL.TheInput
local DEFAULT_FALLBACK_TABLE = GLOBAL.DEFAULT_FALLBACK_TABLE
local DEFAULT_FALLBACK_TABLE_OUTLINE = GLOBAL.DEFAULT_FALLBACK_TABLE_OUTLINE
local FONTS = GLOBAL.FONTS
local mod_interface = require("itemmeta.mod_interface")
local ItemTile = require("widgets/itemtile")
local Inv = require("widgets/inventorybar")

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

-- Keep the tooltip above the cursor
local _ItemTile_GetTooltipPos = ItemTile.GetTooltipPos
function ItemTile:GetTooltipPos()
    -- Allow other mods to position the tooltip
    local basePos = _ItemTile_GetTooltipPos and _ItemTile_GetTooltipPos(self)
    if (basePos) then return basePos end

    local success, result = pcall(function()
        -- Count the number of lines in the tooltip
        local lines = 1
        if self.tooltip and self.tooltip ~= "" then
            for _ in string.gmatch(self.tooltip, "\n") do lines = lines + 1 end
        end

        -- Place the tooltip above the cursor
        return Vector3(0, 10 + 15 * lines, 0)
    end)
    return success and result or basePos
end

-- Prevent the hoverer from messing with the tooltip position near the bottom of the screen
AddClassPostConstruct("widgets/hoverer", function(self)
    local _HoverText_SetPosition = self.SetPosition
    function self:SetPosition(x, y, z)
        pcall(function()
            local cursorY = TheInput:GetScreenPosition().y
            y = math.min(y, cursorY)
        end)
        _HoverText_SetPosition(self, x, y, z)
    end
end)
