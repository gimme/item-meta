local factory = require("itemmeta.itemmeta.ItemMeta_factory")

local interface = {}

--- Returns if the player is holding the button to show the cooked version of the item.
local function ShowCooked()
    return TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) or TheInput:IsControlPressed(CONTROL_FOCUS_RIGHT) or TheInput:IsControlPressed(CONTROL_FOCUS_UP)
end

--- Returns if the player is holding the button to show the alternate metadata of the item.
local function ShowAlternate()
    return TheInput:IsControlPressed(CONTROL_FORCE_STACK) or TheInput:IsControlPressed(CONTROL_FOCUS_LEFT) or TheInput:IsControlPressed(CONTROL_FOCUS_UP)
end

--- Returns the description string for the metadata of the given item.
---@param item table
---@return string
function interface.GetItemMetaDescription(item)
    local showCooked = ShowCooked()
    local showAlternate = ShowAlternate()

    local itemMeta = factory.CreateItemMeta(item.prefab, showCooked)
    local isCooked = showCooked and itemMeta.prefab ~= item.prefab

    return itemMeta:GetDescription(isCooked, showAlternate)
end

return interface
