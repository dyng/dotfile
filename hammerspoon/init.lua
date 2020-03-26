-- Set hyper to ctrl + alt + cmd + shift
local hyper      = {'alt'}

-- Move Mouse to center of next Monitor
hs.hotkey.bind(hyper, '`', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)

    hs.mouse.setAbsolutePosition(center)
    hs.eventtap.leftClick(center)
end)
