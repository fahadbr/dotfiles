-- vim:foldmethod=marker
local hyper = {"ctrl", "alt", "cmd"}
local hyperS = {"ctrl", "alt", "cmd", "shift"}

hs.loadSpoon("MiroWindowsManager")
hs.loadSpoon("WinWin")

hs.window.animationDuration = 0.0
spoon.MiroWindowsManager:bindHotkeys({
    up = {hyper, "up"},
    down = {hyper, "down"},
    right = {hyper, "right"},
    left = {hyper, "left"},
    fullscreen = {hyper, "f"},
    nextscreen = {hyper, "g"}
})

hs.hotkey.bind(hyperS, "r", function()
    hs.reload()
end)

-- helper functions {{{
--
hs.alert.defaultStyle.atScreenEdge = 1
hs.alert.defaultStyle.textSize = 20
modealerts = {}
function makeMode(mods, key, name)
    local mode = hs.hotkey.modal.new(mods, key)
    function mode:entered() modealerts[name] = hs.alert.show(name, hs.alert.defaultStyle, hs.screen.mainScreen(), 'indefinite') end
    function mode:exited() hs.alert.closeSpecific(modealerts[name]) end
    mode:bind('', 'escape', function() mode:exit() end)
    mode:bind('', 'return', function() mode:exit() end)
    return mode
end
-- }}}

-- window movement {{{
--
hs.grid.setGrid(hs.geometry.size(12,6))
hs.grid.setMargins(hs.geometry.size(5,5))

hs.hotkey.bind(hyper, "c", function()
    spoon.WinWin:moveAndResize("center")
end)

function bindMove(key, fn)
    hs.hotkey.bind(hyperS, key, fn, nil, fn)
end

bindMove('h', hs.grid.pushWindowLeft)
bindMove('j', hs.grid.pushWindowDown)
bindMove('k', hs.grid.pushWindowUp)
bindMove('l', hs.grid.pushWindowRight)

hs.hotkey.bind({'alt', 'shift'}, '-', function() hs.window.focusedWindow():sendToBack() end)

hs.hotkey.bind(hyperS, 'right', function()
    hs.window.focusedWindow():moveOneScreenEast(true, true)
end)
hs.hotkey.bind(hyperS, 'left', function()
    hs.window.focusedWindow():moveOneScreenWest(true, true)
end)
-- }}}

-- window/app focus keybindings {{{
hs.hotkey.bind(hyper, 'h', function()
    hs.window.focusedWindow():focusWindowWest(nil, true, true)
end)
hs.hotkey.bind(hyper, 'j', function()
    hs.window.focusedWindow():focusWindowSouth(nil, true, true)
end)
hs.hotkey.bind(hyper, 'k', function()
    hs.window.focusedWindow():focusWindowNorth(nil, true, true)
end)
hs.hotkey.bind(hyper, 'l', function()
    hs.window.focusedWindow():focusWindowEast(nil, true, true)
end)
hs.hotkey.bind(hyper, ';', function()
    hs.hints.windowHints(hs.window.visibleWindows())
end)

appWindowList = {}
appWindowIdx = 1
function bindAppToNum(app, num)
	hs.hotkey.bind(hyper, num, function()
	    if hs.window.focusedWindow():application():name() == app then
		if appWindowList and #appWindowList > 1 then
		    appWindowIdx = math.fmod(appWindowIdx, #appWindowList) + 1
		    appWindowList[appWindowIdx]:focus()
		end
	    else
		hs.application.launchOrFocus(app)
	    end
	end)
end

focusedWindowChangedFilter=hs.window.filter.new(true)
focusedWindowChangedFilter:subscribe(hs.window.filter.windowFocused, function(w)
    appWindowList = hs.application.get(hs.window.focusedWindow():application():name()):allWindows()
    appWindowIdx = 1
end, true)


spaceWatcher = hs.spaces.watcher.new(function(newSpaceNum)
    focusedAppName = hs.window.focusedWindow():application():name()
    appWindowList = hs.application.get(focusedAppName):allWindows()
    appWindowIdx = 1
end)
spaceWatcher:start()

bindAppToNum('Google Chrome', '1')
bindAppToNum('kitty', '2')
bindAppToNum('Workplace Chat', '3')
bindAppToNum('VS Code @ FB', '4')
bindAppToNum('Todoist', '5')
bindAppToNum('Microsoft Outlook', '6')
bindAppToNum('WhatsApp', '7')
bindAppToNum('Firefox', '8')


--visibleWindowFilter = hs.window.filter.new():setOverrideFilter({visible=true,fullscreen=false,currentSpace=true})
--switcher = hs.window.switcher.new(visibleWindowFilter)
--hs.hotkey.bind('alt', 'tab', function() switcher:next() end)
--hs.hotkey.bind('alt-shift', 'tab', function() switcher:previous() end)

-- logic for spaces {{{
--
hs.hotkey.bind(hyperS, 'n', function()
    local currentSpace = hs.spaces.focusedSpace()
    local spacesForScreen = hs.spaces.spacesForScreen(hs.spaces.spaceDisplay(currentSpace))
    local currentSpaceIdx = 0
    for idx, id in pairs(spacesForScreen) do
	if id == currentSpace then
	    currentSpaceIdx = idx
	    break
	end
    end
    if currentSpaceIdx ~= 0 and currentSpaceIdx < #spacesForScreen then
	hs.spaces.openMissionControl()
	hs.spaces.moveWindowToSpace(hs.window.focusedWindow(), spacesForScreen[currentSpaceIdx+1])
	hs.spaces.gotoSpace(spacesForScreen[currentSpaceIdx+1])
	hs.spaces.closeMissionControl()
    end
end)

hs.hotkey.bind(hyperS, 'p', function()
    local currentSpace = hs.spaces.focusedSpace()
    local spacesForScreen = hs.spaces.spacesForScreen(hs.spaces.spaceDisplay(currentSpace))
    local currentSpaceIdx = 0
    for idx, id in pairs(spacesForScreen) do
	if id == currentSpace then
	    currentSpaceIdx = idx
	    break
	end
    end
    if currentSpaceIdx ~= 0 and currentSpaceIdx > 1 then
	hs.spaces.openMissionControl()
	hs.spaces.moveWindowToSpace(hs.window.focusedWindow(), spacesForScreen[currentSpaceIdx-1])
	hs.spaces.gotoSpace(spacesForScreen[currentSpaceIdx-1])
	hs.spaces.closeMissionControl()
    end
end)

function moveWindowToSpace(i)
    local spacesByDisplay = hs.spaces.missionControlSpaceNames()
    for display, idNameTable in pairs(spacesByDisplay) do
	for id, name in pairs(idNameTable) do
	    nameIdx = string.match(name, "%d+")
	    if tonumber(nameIdx) == i then
		window = hs.window.focusedWindow()
		hs.spaces.moveWindowToSpace(window, id)
	    end
	end
    end
end

for i=1, 9 do
    hs.hotkey.bind(hyperS, tostring(i), function() moveWindowToSpace(i) end)
end

-- }}}

-- }}}

-- resize Mode {{{
resize = makeMode(hyper, "return", "resize mode")
function bindResize(mod, key, fn)
    resize:bind(mod, key, fn, nil, fn)
end

bindResize('', 'h', hs.grid.resizeWindowThinner)
bindResize('', 'j', hs.grid.resizeWindowTaller)
bindResize('', 'k', hs.grid.resizeWindowShorter)
bindResize('', 'l', hs.grid.resizeWindowWider)
-- }}}

-- logic for marking module {{{
--
marks = {}
function setWindowWithMark(window, mark)
    marks[mark] = window
end

function removeMark(mark)
    marks[mark] = nil
end

function markFocusedWindow(mark)
    focusedW = hs.window.focusedWindow()
    setWindowWithMark(focusedW, mark)
end

function focusMark(mark)
    id = marks[mark]
    if id then
	id:focus()
    end
end

alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}

markMode = makeMode(hyper, 'm', 'mark mode')
for i=1, #alphabet do
    local key = alphabet[i]
    markMode:bind('', key, function()
	markFocusedWindow(key)
	markMode:exit()
    end)
end

focusMode = makeMode(hyper, 'w', 'focus mode')
for i=1, #alphabet do
    focusMode:bind('', alphabet[i], function()
	focusMark(alphabet[i])
	focusMode:exit()
    end)
end

-- default mark
function setDefaultMark(appname, mark)
    local wf=hs.window.filter
    filter=wf.new(false):setAppFilter(appname, {allowTitles=1})
    filter:subscribe(wf.windowAllowed, function(w)
	setWindowWithMark(w, mark)
    end, true)
    filter:subscribe(wf.windowDestroyed, function()
	removeMark(mark)
    end)
end

setDefaultMark('WhatsApp', 'w')
setDefaultMark('Workplace Chat', 'c')
setDefaultMark('Microsoft Outlook', 'm')
setDefaultMark('Todoist', 't')

-- }}}

-- logic for window highlighting {{{
--
--hs.window.highlight.ui.overlay=true
--hs.window.highlight.ui.overlayColor={1,1,1,0}
--hs.window.highlight.ui.frameWidth=5
--hs.window.highlight.start()
-- }}}

hs.alert.show("Loaded HammerSpoon Config")
