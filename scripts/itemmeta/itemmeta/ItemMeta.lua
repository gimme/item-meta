local describer = require("itemmeta.itemmeta.ItemMeta_describer")
local debug = require("itemmeta.util.debug")

--- Returns the health multiplier if the item is spiced with salt, otherwise 0.
---@return number
local function GetHealthMultiplier(item)
    local result = debug.safecall(function()
        if item:HasTag("spicedfood") and item.components.edible.spice == "SPICE_SALT" then
            return TUNING.SPICE_MULTIPLIERS.SPICE_SALT.HEALTH or 0.25
        end
    end)

    return result or 0
end

--- Returns if the item can be consumed by the player (eat or heal).
---@param item table
---@return boolean
local function CanConsume(item)
    local result = debug.safecall(function()
        assert(ACTIONS.EAT, "ACTIONS.EAT is not defined")

        local actions = {}
        item:CollectActions("INVENTORY", ThePlayer, actions)

        for _, v in ipairs(actions) do
            if v == ACTIONS.EAT or v == ACTIONS.HEAL then return true end
        end

        return false
    end)

    if result == nil then return true end
    return result
end

---@class ItemMeta Metadata for an item type
---@field public prefab string The item's prefab name
---@field public consumable boolean If the item can be consumed (eat/heal)
---@field public damage number Hit points
---@field public fuel number The base fuel of the item (minutes)
---@field public fuelValue number The value if added to a fuel-powered item (seconds)
---@field public health number Healing points
---@field public hp number Max hit points
---@field public hunger number Food points
---@field public insulation number The insulation value
---@field public insulationType string The type of insulation (summer or winter)
---@field public perishTime number The time it takes to perish (days)
---@field public protection number The protection value (%)
---@field public sanity number Sanity points
---@field public sanityRestore number Sanity points per minute
---@field public uses number The max number of uses
---@field public waterResist number The wetness resistance value (%)
---@field public wearTime number The time it takes to wear out (days)
---@field public wearUses number The max number of wear-related uses
local ItemMeta = Class(function(self, inst)
    if not inst then return end

    self.prefab = inst.prefab
    self.consumable = CanConsume(inst)

    if not inst.components then return end

    if inst.components.equippable then
        local dapperness = inst.components.equippable.dapperness
        self.sanityRestore = dapperness ~= 0 and dapperness and dapperness * 60
    end

    if inst.components.perishable then
        local perishTime = inst.components.perishable.perishtime
        self.perishTime = perishTime ~= 0 and perishTime and perishTime / TUNING.TOTAL_DAY_TIME
    end

    if inst.components.insulator then
        self.insulation = inst.components.insulator.insulation ~= 0 and inst.components.insulator.insulation
        self.insulationType = inst.components.insulator.type == SEASONS.SUMMER and SEASONS.SUMMER or SEASONS.WINTER
    end

    if inst.components.waterproofer then
        local effectiveness = inst.components.waterproofer:GetEffectiveness()
        self.waterResist = effectiveness ~= 0 and effectiveness and effectiveness * 100
    end


    if inst.components.finiteuses then
        local total = inst.components.finiteuses.total or 0
        local consumption
        for _, v in pairs(inst.components.finiteuses.consumption or {}) do consumption = v break end

        if total ~= 0 and consumption and consumption ~= 0 then
            local uses = total / consumption
            self.uses = math.ceil(uses)
        end
    end

    if inst.components.weapon then
        self.damage = inst.components.weapon.damage ~= 0 and inst.components.weapon.damage
    end

    if inst.components.fueled and inst.prefab ~= "heatrock" then
        local fuelType = inst.components.fueled.fueltype
        local maxFuel = inst.components.fueled.maxfuel

        if maxFuel and maxFuel ~= 0 then
            if fuelType == FUELTYPE.USAGE then
                self.wearTime = maxFuel / TUNING.TOTAL_DAY_TIME
            else
                self.fuel = maxFuel / 60
            end
        end
    end

    if inst.components.fuel then
        self.fuelValue = inst.components.fuel.fuelvalue ~= 0 and inst.components.fuel.fuelvalue
    end

    if inst.components.armor then
        local absorbPercent = inst.components.armor.absorb_percent
        self.protection = absorbPercent ~= 0 and absorbPercent and absorbPercent * 100

        self.hp = inst.components.armor.maxcondition ~= 0 and inst.components.armor.maxcondition
    end

    if inst.components.edible then
        local edible = inst.components.edible
        self.hunger = edible.hungervalue ~= 0 and edible.hungervalue
        self.sanity = edible.sanityvalue ~= 0 and edible.sanityvalue
        self.health = edible.healthvalue ~= 0 and edible.healthvalue and (edible.healthvalue * (1 + GetHealthMultiplier(inst)))
    end

    if inst.components.healer then
        self.health = inst.components.healer.health ~= 0 and inst.components.healer.health
    end

    -- Thermal Stone and Thermbell
    if TUNING.HEATROCK_NUMUSES and inst:HasTag("heatrock") then
        self.wearUses = TUNING.HEATROCK_NUMUSES
    end
end)

--- Returns the description string for the metadata of the item.
---@param cooked boolean If the description is for the cooked version of the item
---@param alternate boolean If the alternate metadata should be shown
---@return string
function ItemMeta:GetDescription(cooked, alternate)
    return describer.GetDescription(self, cooked, alternate)
end

return ItemMeta
