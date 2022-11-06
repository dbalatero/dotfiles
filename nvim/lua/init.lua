-- Stage 1. Load the basic editor config/support before plugins.
require('config.utils').requireConfigDirectory("support")

-- Stage 2. Load the plugins in
require('plugins')

-- Stage 3. Apply the theme
require("theme")
