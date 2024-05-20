-- vim:foldmethod=marker
local hyper = {"ctrl", "alt", "cmd"}
local hyperS = {"ctrl", "alt", "cmd", "shift"}

hs.loadSpoon("WinWin")

hs.window.animationDuration = 0.0

hs.hotkey.bind(hyperS, "r", function()
    hs.reload()
end)

-- helper functions {{{
--
hs.alert.defaultStyle.atScreenEdge = 0
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

local function bindMove(key, fn)
    hs.hotkey.bind(hyperS, key, fn, nil, fn)
end

bindMove('h', hs.grid.pushWindowLeft)
bindMove('j', hs.grid.pushWindowDown)
bindMove('k', hs.grid.pushWindowUp)
bindMove('l', hs.grid.pushWindowRight)

--hs.hotkey.bind({'alt', 'shift'}, '-', function() hs.window.focusedWindow():sendToBack() end)

hs.hotkey.bind(hyperS, 'right', function()
    hs.window.focusedWindow():moveOneScreenEast(true, true)
end)
hs.hotkey.bind(hyperS, 'left', function()
    hs.window.focusedWindow():moveOneScreenWest(true, true)
end)
-- }}}

-- resize Mode {{{
resize = makeMode(hyper, "return", "resize/move mode")

-- use this function for repeating keys
function bindResizeRepeat(mod, key, fn)
    resize:bind(mod, key, fn, nil, fn)
end

bindResizeRepeat('shift', 'h', hs.grid.resizeWindowThinner)
bindResizeRepeat('shift', 'j', hs.grid.resizeWindowTaller)
bindResizeRepeat('shift', 'k', hs.grid.resizeWindowShorter)
bindResizeRepeat('shift', 'l', hs.grid.resizeWindowWider)

bindResizeRepeat('', 'h', hs.grid.pushWindowLeft)
bindResizeRepeat('', 'j', hs.grid.pushWindowDown)
bindResizeRepeat('', 'k', hs.grid.pushWindowUp)
bindResizeRepeat('', 'l', hs.grid.pushWindowRight)

function bindGrid(mod, key, x, y, w, h)
    resize:bind(mod, key, function()
	hs.grid.set(hs.window.focusedWindow(), hs.geometry.rect(x,y,w,h))
    end)
end

-- resize and move in thirds of screen
bindGrid('', 'x', 0,0,4,6)
bindGrid('', 'c', 4,0,4,6)
bindGrid('', 'v', 8,0,4,6)
-- resize and move in halves of screen
bindGrid('', 's', 0,0,6,6)
bindGrid('', 'd', 3,0,6,6)
bindGrid('', 'f', 6,0,6,6)
-- resize and move in 2/3s of screen
bindGrid('', 'w', 0,0,8,6)
bindGrid('', 'e', 2,0,8,6)
bindGrid('', 'r', 4,0,8,6)

-- resize and move to corner regions of screen with half width and height
bindGrid('shift', 'w', 0,0,6,3)
bindGrid('shift', 'x', 0,3,6,3)
bindGrid('shift', 'r', 6,0,6,3)
bindGrid('shift', 'v', 6,3,6,3)

-- resize and move to corner regions of screen with 1/3 width and 1/2 height
bindGrid({'cmd', 'shift'}, 'w', 0,0,4,3)
bindGrid({'cmd', 'shift'}, 'x', 0,3,4,3)
bindGrid({'cmd', 'shift'}, 'r', 8,0,4,3)
bindGrid({'cmd', 'shift'}, 'v', 8,3,4,3)

hs.hotkey.bind(hyper, 'f', function()
    hs.grid.set(hs.window.focusedWindow(), hs.geometry.rect(0,0,12,6))
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
appWindowIdx = 0
currentAppName = ''
lastAppName = ''
function resetCurrentApp(newAppName)
    appWindowList = hs.application.get(newAppName):allWindows()
    appWindowIdx = 0
    if newAppName ~= currentAppName then
	lastAppName = currentAppName
	currentAppName = newAppName
    end
end

function bindAppToNum(app, num)
    hs.hotkey.bind(hyper, num, function()
	if hs.window.focusedWindow():application():name() == app then
	    --if appWindowList and #appWindowList > 1 then
		--appWindowIdx = math.fmod(appWindowIdx+1, #appWindowList)
		--appWindowList[appWindowIdx + 1]:focus()
	    --end
	    hs.application.launchOrFocus(lastAppName)
	else
	    hs.application.launchOrFocus(app)
	end
    end)
end


focusedWindowChangedFilter=hs.window.filter.new(true)
focusedWindowChangedFilter:subscribe(hs.window.filter.windowFocused, function(w)
    local newAppName = hs.window.focusedWindow():application():name()
    if currentAppName ~= newAppName then
	resetCurrentApp(newAppName)
    end
end, true)


spaceWatcher = hs.spaces.watcher.new(function(newSpaceNum)
    resetCurrentApp(hs.window.focusedWindow():application():name())
end)
spaceWatcher:start()

bindAppToNum('Google Chrome', '1')
bindAppToNum('kitty', '2')
bindAppToNum('TickTick', '3')
bindAppToNum('Messages', '4')
bindAppToNum('zoom.us', '5')
bindAppToNum('Calendar', '6')
bindAppToNum('Slack', '7')


visibleWindowFilter = hs.window.filter.new():setOverrideFilter({visible=true})
switcher = hs.window.switcher.new(visibleWindowFilter)
switcher.ui.showThumbnails = false
switcher.ui.showSelectedThumbnail = false
switcher.ui.textSize = 10
--switcher.ui.thumbnailSize = 100
hs.hotkey.bind('alt', 'tab', function() switcher:next() end)
hs.hotkey.bind('alt-shift', 'tab', function() switcher:previous() end)

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
-- -- No longer needed since i'm doing app switching
-- -- by hotkey
--function setDefaultMark(appname, mark)
    --local wf=hs.window.filter
    --filter=wf.new(false):setAppFilter(appname, {allowTitles=1})
    --filter:subscribe(wf.windowAllowed, function(w)
	--setWindowWithMark(w, mark)
    --end, true)
    --filter:subscribe(wf.windowDestroyed, function()
	--removeMark(mark)
    --end)
--end

--setDefaultMark('WhatsApp', 'w')
--setDefaultMark('Workplace Chat', 'c')
--setDefaultMark('Microsoft Outlook', 'm')
--setDefaultMark('Todoist', 't')

-- }}}

-- logic for window highlighting {{{
--
--hs.window.highlight.ui.overlay=true
--hs.window.highlight.ui.overlayColor={1,1,1,0}
--hs.window.highlight.ui.frameWidth=5
--hs.window.highlight.start()
-- }}}

-- shortcut to type clipboard {{{

-- -- use this to type out the clipboard
-- -- useful for when you cant paste into an application
-- -- like a VDI
hs.hotkey.bind(hyper, 'v', function ()
    local clipboardContents = hs.pasteboard.getContents()
    if clipboardContents == nil then
	hs.alert.show("nil or invalid clipboard")
	return
    end

    hs.eventtap.keyStrokes(clipboardContents)
end)


-- }}}

-- {{{ event tap
--local events = hs.eventtap.event.types
--local logger = hs.logger.new("keytracker", "debug")
--local heldDown = false
--local heldDownTime = 0

-- Cases to handle
-- A_MOD_DOWN B_DOWN B_UP A_MOD_UP => MOD+B
-- A_MOD_DOWN B_DOWN A_MOD_UP B_UP => A,B
-- A_MOD_DOWN A_MOD_UP => A if < .5 sec between keydown and keyup
-- A_MOD_DOWN A_MOD_UP A_MOD_DOWN A_MOD_UP => A repeated if doubled tapped
-- keyDownTracker = hs.eventtap.new({ events.keyDown, events.keyUp }, function (e)
--   local keyCode = e:getKeyCode()
--   local eventType = e:getType(true)
--   local eventDesc = ""
--   if eventType == events.keyDown then
--       eventDesc = "KEYDOWN"
--       if keyCode == 3 and not heldDown then
--       	heldDown = true
-- 	heldDownTime = e:timestamp()
--       end
--   elseif eventType == events.keyUp then
--       eventDesc = "KEYUP"
--       if keyCode == 3 then
--       	heldDown = false
-- 	keyUpTime = e:timestamp()
-- 	--i
--       end
--   end
--
--   local deleteOriginalKey = keyCode == 3 and heldDown
--   if heldDown == true then
--       local currentFlags = e:getFlags()
--       currentFlags.ctrl = true
--       e:setFlags(currentFlags)
--   end
--
--   logger.df("%s keycode %d, timestamp: %d", eventDesc, keyCode, e:timestamp())
--   return deleteOriginalKey
-- end)
--keyDownTracker:start()


-- }}}

hs.alert.show("Loaded HammerSpoon Config")
