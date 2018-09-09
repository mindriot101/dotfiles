function launchTerminal()
    hs.application.launchOrFocus('Terminal')
end

function launchEditor()
    hs.application.launchOrFocus('Visual Studio Code')
end

function launchEmail()
    hs.application.launchOrFocus('Mail')
end

-- Terminal
hs.hotkey.bind({'cmd', 'alt'}, 't', launchTerminal)

-- Browser
hs.hotkey.bind({'cmd', 'alt'}, 'c', function()
    hs.application.launchOrFocus('Firefox')
end)

-- Editor
hs.hotkey.bind({'cmd', 'alt'}, 'e', launchEmail)

-- Switch between editor and terminal
hs.hotkey.bind({'cmd', 'alt'}, 's', function()
    local currentApplication = hs.application.frontmostApplication()
    local currentApplicationName = currentApplication:name():lower()
    if currentApplicationName == 'code' then
        hs.application.launchOrFocus('Kitty')
    elseif currentApplicationName == 'kitty' then
        hs.application.launchOrFocus('Visual Studio Code')
    end
end)
