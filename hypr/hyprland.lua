local config_dir = (os.getenv("HOME") or "") .. "/.config/hypr"
package.path = table.concat({
    config_dir .. "/?.lua",
    config_dir .. "/?/init.lua",
    package.path,
}, ";")

for _, mod in ipairs({
    "configs.display",
    "configs.input",
    "configs.keybinds",
    "configs.exec",
    "theme.theme",
    "configs.animations",
    "configs.key_exec",
    "configs.misc",
    "configs.workspaces",

}) do
    package.loaded[mod] = nil
end

require("configs.display")
require("configs.input")
require("configs.keybinds")
require("configs.exec")
require("theme.theme")
require("configs.animations")
require("configs.key_exec")
require("configs.misc")
require("configs.workspaces")
