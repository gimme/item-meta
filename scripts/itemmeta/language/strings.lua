local strings = {
    DAYS = "days",
    HP = "hp",
    IF_COOKED = "If Cooked:",
    MINUTE = "min",
    SECOND = "sec",
    USES = "uses",
}


--- Loads the translations for the given language.
---@param languageCode string
local function LoadTranslations(languageCode)
    local translations = require("itemmeta.language.translations." .. languageCode)

    for key, value in pairs(translations) do
        strings[key] = value
    end
end

-- Load translations for the current language, overriding the default English strings.
pcall(function()
    local loc = require("languages/loc")
    local code = loc and loc.CurrentLocale and loc.CurrentLocale.code
    if code == "zhr" then code = "zh" end
    if code and code ~= "en" then LoadTranslations(code) end
end)

return strings
