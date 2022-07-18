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
hs.hotkey.bind(hyper, "c", function()
    spoon.WinWin:moveAndResize("center")
end)

function bindMove(key, direction)
    fn = function() spoon.WinWin:stepMove(direction) end
    hs.hotkey.bind(hyperS, key, fn, nil, fn)
end
bindMove('h', 'left')
bindMove('j', 'down')
bindMove('k', 'up')
bindMove('l', 'right')

hs.hotkey.bind({'alt', 'shift'}, '-', function() hs.window.focusedWindow():sendToBack() end)

-- move window focus directionally
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
hs.hotkey.bind(hyperS, 'right', function()
    spoon.WinWin:moveToScreen('right')
end)
hs.hotkey.bind(hyperS, 'left', function()
    spoon.WinWin:moveToScreen('left')
end)
hs.hotkey.bind(hyper, ';', function()
    hs.hints.windowHints(hs.window.visibleWindows())
end)

--visibleWindowFilter = hs.window.filter.new():setOverrideFilter({visible=true,fullscreen=false,currentSpace=true})
--switcher = hs.window.switcher.new(visibleWindowFilter)
--hs.hotkey.bind('alt', 'tab', function() switcher:next() end)
--hs.hotkey.bind('alt-shift', 'tab', function() switcher:previous() end)

-- logic for spaces {{{
--
function moveWindowToSpace(i)
    spacesByDisplay = hs.spaces.missionControlSpaceNames()
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
--resize = hs.hotkey.modal.new(hyper, "r", "resize mode")
resize = makeMode(hyper, "r", "resize/move mode")
function bindResize(mod, key, direction)
    local fn = function() spoon.WinWin:stepResize(direction) end
    resize:bind(mod, key, fn, nil, fn)
end
function bindMoveMode(key, direction)
    fn = function() spoon.WinWin:stepMove(direction) end
    resize:bind('', key, fn, nil, fn)
end
bindMoveMode('h', 'left')
bindMoveMode('j', 'down')
bindMoveMode('k', 'up')
bindMoveMode('l', 'right')

bindResize({'shift'}, 'h', 'left')
bindResize({'shift'}, 'j', 'down')
bindResize({'shift'}, 'k', 'up')
bindResize({'shift'}, 'l', 'right')
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
    filter=wf.new{appname}
    filter:subscribe(wf.windowAllowed, function(w)
	setWindowWithMark(w, mark)
    end, true)
    filter:subscribe(wf.windowDestroyed, function()
	removeMark(mark)
    end)
end

setDefaultMark('WhatsApp', 'w')
setDefaultMark('Workplace Chat', 'c')
setDefaultMark('Outlook', 'm')
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
