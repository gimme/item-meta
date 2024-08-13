local debug = {}

--- Prints with a prefix.
function debug.log(...)
    print("[Item Meta]", ...)
end

--- Safely calls a function and logs any errors.
---@param fn function
---@vararg any
---@return any The result of the function or nil if an error occurred
function debug.safecall(fn, ...)
    local success, result = pcall(fn, ...)
    if success then return result end
    debug.log("Error:", result)
    return nil
end

return debug
