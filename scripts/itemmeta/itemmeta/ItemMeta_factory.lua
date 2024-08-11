local ItemMeta = require("itemmeta.itemmeta.ItemMeta")
local debug = require("itemmeta.util.debug")

local factory = {}

--- Cache of ItemMetas, indexed by prefab.
local itemMetas = {}
--- Cache of prefabs of the cooked versions of items, indexed by the raw item prefab.
local cookedPrefabs = {}

--- Spawns an item and its cooked version (if applicable) and removes them from the world.
---@param prefab string
---@return table, table The item, and its cooked version if applicable
local function SpawnAndRemoveItem(prefab)
    local isMasterSim = TheWorld.ismastersim
    local allPlayers = AllPlayers
    TheWorld.ismastersim = true
    AllPlayers = {}

    local itemCopy = debug.safecall(SpawnPrefab, prefab)
    local itemCopyCooked

    if itemCopy then
        if itemCopy.components and itemCopy.components.cookable then
            local campfire = debug.safecall(SpawnPrefab, "campfire")
            debug.safecall(function()
                itemCopyCooked = itemCopy.components.cookable:Cook(campfire, ThePlayer)
                itemCopyCooked:Remove()
            end)
            debug.safecall(function() campfire:Remove() end)
        end

        debug.safecall(function() itemCopy:Remove() end)
    end

    TheWorld.ismastersim = isMasterSim
    AllPlayers = allPlayers

    return itemCopy, itemCopyCooked
end

--- Caches the metadata of the item and its cooked version (if applicable).
---@param prefab string
local function CacheItemMeta(prefab)
    -- Return if the item is already cached
    if itemMetas[prefab] then return end

    -- Spawn the item
    local itemCopy, itemCopyCooked = SpawnAndRemoveItem(prefab)

    -- Cache the raw item
    itemMetas[prefab] = ItemMeta(itemCopy)

    -- Cache the cooked version if it exists
    if itemCopyCooked then
        cookedPrefabs[itemCopy.prefab] = itemCopyCooked.prefab
        itemMetas[itemCopyCooked.prefab] = ItemMeta(itemCopyCooked)
    end
end

--- Returns the item metadata for the given prefab.
---@param prefab string
---@param tryCooked boolean If the cooked version of the item should be returned if possible
---@return ItemMeta
function factory.CreateItemMeta(prefab, tryCooked)
    -- Ensure the item and its cooked version (if applicable) are cached
    CacheItemMeta(prefab)

    -- Return the cooked version if requested and available
    if tryCooked then
        local cookedPrefab = cookedPrefabs[prefab]
        if cookedPrefab and itemMetas[cookedPrefab] then
            return itemMetas[cookedPrefab]
        end
    end

    -- Return the raw item metadata
    return itemMetas[prefab]
end

return factory
