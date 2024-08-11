local debug = {}

--- Safely calls a function and logs any errors.
---@param fn function
---@vararg any
---@return any The result of the function or nil if an error occurred
function debug.safecall(fn, ...)
    local success, result = pcall(fn, ...)
    if success then return result end
    print("Error:", result)
    return nil
end

return debug
