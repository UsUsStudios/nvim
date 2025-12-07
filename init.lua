require("config.options")
require("config.lazy")
require("config.keymaps")
local lspconfig = require('lspconfig')
lspconfig.pylsp.setup{}