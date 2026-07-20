-- Application hotkeys migrated from Keyboard Maestro's
-- "Application Launcher" group on 2026-07-18.
local appHotkeys = {
    {
        modifiers = { "cmd" },
        key = "e",
        name = "VimR",
        bundleID = "com.qvacua.VimR",
        path = "/Applications/VimR.app",
    },
    {
        modifiers = { "cmd" },
        key = "i",
        name = "Google Chrome",
        bundleID = "com.google.Chrome",
        path = "/Applications/Google Chrome.app",
    },
    {
        modifiers = { "cmd" },
        key = "m",
        name = "iTerm",
        bundleID = "com.googlecode.iterm2",
        path = "/Applications/iTerm.app",
    },
    {
        modifiers = { "cmd" },
        key = "u",
        name = "ChatGPT",
        bundleID = "com.openai.codex",
        path = "/Applications/ChatGPT.app",
    },
    {
        modifiers = { "cmd", "ctrl" },
        key = "m",
        name = "NetEaseMusic",
        bundleID = "com.netease.163music",
        path = "/Applications/NeteaseMusic.app",
    },
    {
        modifiers = { "cmd", "ctrl" },
        key = "w",
        name = "WeCom",
        bundleID = "com.tencent.WeWorkMac",
        path = "/Applications/企业微信.app",
    },
    {
        modifiers = { "cmd", "ctrl" },
        key = "n",
        name = "Notion",
        bundleID = "notion.id",
        path = "/Applications/Notion.app",
    },
}

local function launchOrFocus(appConfig)
    local runningApp = hs.application.get(appConfig.bundleID)
    if runningApp then
        -- Keyboard Maestro had "All Windows" enabled for these actions.
        runningApp:activate(true)
        return
    end

    if hs.application.launchOrFocusByBundleID(appConfig.bundleID) then
        return
    end

    if hs.fs.attributes(appConfig.path) and hs.application.open(appConfig.path) then
        return
    end

    hs.alert.show("找不到应用：" .. appConfig.name)
end

for _, appConfig in ipairs(appHotkeys) do
    hs.hotkey.bind(appConfig.modifiers, appConfig.key, function()
        launchOrFocus(appConfig)
    end)
end

-- Kawa used Option-Space to select the ABC input source directly.
local abcInputSourceID = "com.apple.keylayout.ABC"

hs.hotkey.bind({ "alt" }, "space", function()
    if not hs.keycodes.currentSourceID(abcInputSourceID) then
        hs.alert.show("无法切换到 ABC 输入法")
    end
end)

-- Move the mouse to the center of the next monitor.
hs.hotkey.bind({ "alt" }, "`", function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local center = hs.geometry.rectMidPoint(nextScreen:fullFrame())

    hs.mouse.setAbsolutePosition(center)
end)

-- Present in Keyboard Maestro but intentionally not migrated as active bindings:
--   Control-Command-I -> IntelliJ IDEA CE (macro disabled)
--   WeChat activation action (no hotkey assigned)

hs.alert.show("Hammerspoon 配置已加载")
