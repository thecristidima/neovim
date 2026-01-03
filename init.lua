-- Define some global variables to be available in all other scripts
local uname = vim.loop.os_uname()
_G.IS_MAC = uname.sysname == "Darwin"
_G.IS_LINUX = uname.sysname == "Linux"
_G.IS_WINDOWS = uname.sysname == "Windows_NT"

require("config.lazy")
require("config.editor")
require("config.keymaps")
require("config.post_setup")
