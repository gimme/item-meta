name = "Item Meta"
description = "Displays extra metadata in item tooltips."
author = "gimmeh"
version = "0.3.0"
forumthread = ""
api_version = 10
api_version_dst = 10
priority = -10

-- Custom icon
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- Client mod
client_only_mod = true
-- If clients need the mod to join the server
all_clients_require_mod = false

-- Compatible with Don't Starve Together
dst_compatible = true
-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- These tags allow the server running this mod to be found with filters from the server listing screen
server_filter_tags = {""}

-- Configuration options
configuration_options =
{
    {
        name = "FOOD_FORMAT",
        label = "Food Format",
        hover = "If hunger/health/sanity should be displayed on the same (H) or separate (V) rows. (Default: Horizontal)",
        options = {
            {description = "Default", data = ""},
            {description = "Horizontal", data = "h"},
            {description = "Vertical", data = "v"},
        },
        default = "",
    },
    {
        name = "FOOD_ORDER",
        label = "Food Order",
        hover = "Which order hunger/health/sanity should be displayed in. (Default: hu/he/sa)",
        options = {
            {description = "Default", data = ""},
            {description = "hu/he/sa", data = "hu/he/sa"},
            {description = "hu/sa/he", data = "hu/sa/he"},
            {description = "he/hu/sa", data = "he/hu/sa"},
        },
        default = "",
    },
    {
        name = "FORCE_ENABLE",
        label = "Force Enable",
        hover = "Forces the mod to be enabled regardless of other mods. (Default: False)",
        options = {
            {description = "False", data = ""},
            {description = "True", data = "true"},
        },
        default = "",
    },
}
