-- Define some global variables to be available in all other scripts
local uname = vim.loop.os_uname()
_G.IS_MAC = uname.sysname == "Darwin"
_G.IS_LINUX = uname.sysname == "Linux"
_G.IS_WINDOWS = uname.sysname == "Windows_NT"
_G.IS_WSL = _G.IS_LINUX and (
    vim.env.WSL_DISTRO_NAME ~= nil
    or vim.env.WSL_INTEROP ~= nil
    or uname.release:lower():find("microsoft", 1, true) ~= nil
)

require("config.lazy")
require("config.editor")
require("config.keymaps")
require("config.post_setup")
