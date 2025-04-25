-- vim:foldmethod=marker:ts=2:sw=2:expandtab
local hyper = { 'ctrl', 'alt', 'cmd' }
local hyperS = { 'ctrl', 'alt', 'cmd', 'shift' }

hs.loadSpoon('WinWin')

hs.window.animationDuration = 0.0

hs.hotkey.bind(hyperS, 'r', function()
  hs.reload()
end)

-- helper functions {{{
--
hs.alert.defaultStyle.atScreenEdge = 0
hs.alert.defaultStyle.textSize = 16
hs.alert.defaultStyle.textFont = 'FiraCode Nerd Font Mono'
hs.alert.defaultStyle.radius = 10
hs.alert.defaultStyle.fillColor = { white = 0.1, alpha = 1 }
modealerts = {}
function makeMode(mods, key, name)
  local mode = hs.hotkey.modal.new(mods, key)
  function mode:entered()
    modealerts[name] = hs.alert.show(name, hs.alert.defaultStyle, hs.screen.mainScreen(), 'indefinite')
  end

  function mode:exited()
    hs.alert.closeSpecific(modealerts[name])
  end

  mode:bind('', 'escape', function()
    mode:exit()
  end)
  mode:bind('', 'return', function()
    mode:exit()
  end)
  return mode
end

-- }}}

-- window movement {{{
--
hs.grid.setGrid(hs.geometry.size(12, 6))
hs.grid.setMargins(hs.geometry.size(5, 5))

local function bindMove(key, fn)
  hs.hotkey.bind(hyperS, key, fn, nil, fn)
end

bindMove('c', function()
  spoon.WinWin:moveAndResize('center')
end)
bindMove('h', hs.grid.pushWindowLeft)
bindMove('j', hs.grid.pushWindowDown)
bindMove('k', hs.grid.pushWindowUp)
bindMove('l', hs.grid.pushWindowRight)

--hs.hotkey.bind({'alt', 'shift'}, '-', function() hs.window.focusedWindow():sendToBack() end)
-- }}}

-- resize Mode {{{
resize = makeMode(hyper, 'return', 'resize/move mode')

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
    hs.grid.set(hs.window.focusedWindow(), hs.geometry.rect(x, y, w, h))
  end)
end

-- resize and move in thirds of screen
bindGrid('', 'x', 0, 0, 4, 6)
bindGrid('', 'c', 4, 0, 4, 6)
bindGrid('', 'v', 8, 0, 4, 6)
-- resize and move in halves of screen
bindGrid('', 's', 0, 0, 6, 6)
bindGrid('', 'd', 3, 0, 6, 6)
bindGrid('', 'f', 6, 0, 6, 6)
-- resize and move in 2/3s of screen
bindGrid('', 'w', 0, 0, 8, 6)
bindGrid('', 'e', 2, 0, 8, 6)
bindGrid('', 'r', 4, 0, 8, 6)

-- resize and move to corner regions of screen with half width and height
bindGrid('shift', 'w', 0, 0, 6, 3)
bindGrid('shift', 'x', 0, 3, 6, 3)
bindGrid('shift', 'r', 6, 0, 6, 3)
bindGrid('shift', 'v', 6, 3, 6, 3)

-- resize and move to corner regions of screen with 1/3 width and 1/2 height
bindGrid({ 'cmd', 'shift' }, 'w', 0, 0, 4, 3)
bindGrid({ 'cmd', 'shift' }, 'x', 0, 3, 4, 3)
bindGrid({ 'cmd', 'shift' }, 'r', 8, 0, 4, 3)
bindGrid({ 'cmd', 'shift' }, 'v', 8, 3, 4, 3)

hs.hotkey.bind(hyper, 'f', function()
  hs.grid.set(hs.window.focusedWindow(), hs.geometry.rect(0, 0, 12, 6))
end)

-- }}}

-- window/app focus keybindings {{{
-- hs.hotkey.bind(hyper, 'h', function()
--   hs.window.focusedWindow():focusWindowWest(nil, true, true)
-- end)
-- hs.hotkey.bind(hyper, 'j', function()
--   hs.window.focusedWindow():focusWindowSouth(nil, true, true)
-- end)
-- hs.hotkey.bind(hyper, 'k', function()
--   hs.window.focusedWindow():focusWindowNorth(nil, true, true)
-- end)
-- hs.hotkey.bind(hyper, 'l', function()
--   hs.window.focusedWindow():focusWindowEast(nil, true, true)
-- end)
-- hs.hotkey.bind(hyper, ';', function()
--   hs.hints.windowHints(hs.window.visibleWindows())
-- end)
--
-- appMode = makeMode(hyper, 'a', 'application mode')
-- appMode:bind('', 'n', function()
--   window = hs.window.find('Obsidian'):focus()
--   appMode:exit()
-- end)
-- appMode:bind('', 'i', function()
--   window = hs.window.find('IB - '):focus()
--   appMode:exit()
-- end)

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

alphabet = {
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
}

markMode = makeMode(hyper, 'm', 'mark mode')
for i = 1, #alphabet do
  local key = alphabet[i]
  markMode:bind('', key, function()
    markFocusedWindow(key)
    markMode:exit()
  end)
end

focusMode = makeMode(hyper, 'w', 'focus mode')
for i = 1, #alphabet do
  focusMode:bind('', alphabet[i], function()
    focusMark(alphabet[i])
    focusMode:exit()
  end)
end

-- }}}

-- caffinate automator {{{

citrixwatcher = hs.application.watcher.new(function(appName, event, appObj)
  if appObj:name() == 'Citrix Viewer' then
    -- for initiating the caffeinate assertion
    -- the correct event to watch for should actually be "launched"
    -- but for some reason this never gets received for "Citrix Viewer"
    -- the next best thing is to check for when its focused and add an additional
    -- check to see if we already set the displayIdle assertion
    if event == hs.application.watcher.activated and hs.caffeinate.get('displayIdle') == false then
      --start caffeinate
      hs.alert.show('Caffeinate Started')
      hs.caffeinate.set('displayIdle', true, false)
    elseif event == hs.application.watcher.terminated then
      -- the below check makes sure that citrix is no longer running
      -- there are some cases where other citrix apps have been opened
      -- and quit while the main citrix app still remains open
      if hs.application.get('Citrix Viewer') == nil then
        -- end caffeinate
        hs.alert.show('Caffeinate Terminated')
        hs.caffeinate.set('displayIdle', false, false)
      end
    end
  end
  -- print statement for debugging
  --hs.printf('app: ' .. appObj:name() .. ' , event: ' .. event)
end)

citrixwatcher:start()

-- }}}

-- helpful keybindings for shortcuts {{{

-- -- use this to type out the clipboard
-- -- useful for when you cant paste into an application
-- -- like a VDI

-- Zoom Mode {{{
zoomModeText = [[
Zoom Mode

Focus Zoom          = hyper+enter
Toggle Audio        = hyper+z
Toggle Video        = hyper+v
Leave Meeting       = hyper+x
Copy Invite Link    = hyper+c
Toggle Minimal View = m]]
zoomMode = makeMode(hyper, 'z', zoomModeText)

zoomMode:bind(hyper, 'return', function()
  hs.application.launchOrFocus('zoom.us')
  zoomMode:exit()
end)

-- toggle audio mute
zoomMode:bind(hyper, 'z', function()
  zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Mute audio' }) then
      zoom:selectMenuItem({ 'Meeting', 'Mute audio' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Unmute audio' })
    end
  end
  zoomMode:exit()
end)

-- toggle video on
zoomMode:bind(hyper, 'v', function()
  zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Start video' }) then
      zoom:selectMenuItem({ 'Meeting', 'Start video' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Stop video' })
    end
  end
  zoomMode:exit()
end)

-- toggle minimal view
zoomMode:bind('', 'm', function()
  zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Exit minimal view' }) then
      zoom:selectMenuItem({ 'Meeting', 'Exit minimal view' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Enter minimal view' })
    end
  end
  zoomMode:exit()
end)

zoomMode:bind(hyper, 'c', function()
  zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    zoom:selectMenuItem({ 'Meeting', 'Copy invite link' })
  end
  zoomMode:exit()
end)

zoomMode:bind(hyper, 'x', function()
  zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Exit minimal view' }) then
      zoom:selectMenuItem({ 'Meeting', 'Exit minimal view' })
    end
    zoom:activate()
    hs.eventtap.keyStroke({ 'cmd' }, 'w')
  end
  zoomMode:exit()
end)

-- }}}

-- Browser Mode {{{

browserModeText = [[
Browser Mode

Focus Browser    = hyper+enter
Search Bookmarks = hyper+b
Search Tabs      = hyper+t
Open ChatGPT     = hyper+c]]
browserMode = makeMode(hyper, 'b', browserModeText)

browserMode:bind(hyper, 'return', function()
  hs.application.launchOrFocus('Firefox')
  browserMode:exit()
end)

-- search bookmarks in firefox
browserMode:bind(hyper, 'b', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  firefox:selectMenuItem({ 'Bookmarks', 'Search Bookmarks' })
  browserMode:exit()
end)

-- search tabs in firefox
browserMode:bind(hyper, 't', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  --hs.eventtap.keyStroke({'cmd'}, "l")
  hs.eventtap.keyStrokes('@tabs ')
  browserMode:exit()
end)

-- go to chatgpt
browserMode:bind(hyper, 'c', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  browserMode:exit()
end)

-- }}}

-- Terminal Mode {{{
terminalModeText = [[
Terminal Mode

Focus Terminal   = hyper+enter
Dotfiles Session = hyper+d
Open Session     = hyper+o ]]
terminalMode = makeMode(hyper, 't', terminalModeText)

terminalMode:bind(hyper, 'return', function()
  hs.application.launchOrFocus('kitty')
  terminalMode:exit()
end)

terminalMode:bind(hyper, 'd', function()
  local term = hs.application.get('kitty')
  term:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'd', 50000)
  terminalMode:exit()
end)

terminalMode:bind(hyper, 't', function()
  local term = hs.application.get('kitty')
  term:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 't', 50000)
  terminalMode:exit()
end)

terminalMode:bind(hyper, 'b', function()
  local term = hs.application.get('kitty')
  term:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'b', 50000)
  terminalMode:exit()
end)

terminalMode:bind(hyper, 'o', function()
  local term = hs.application.get('kitty')
  term:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'o', 50000)
  terminalMode:exit()
end)
-- }}}

hs.hotkey.bind(hyper, 'v', function()
  local clipboardContents = hs.pasteboard.getContents()
  if clipboardContents == nil then
    hs.alert.show('nil or invalid clipboard')
    return
  end

  hs.timer.doAfter(1, function()
    hs.eventtap.keyStrokes(clipboardContents)
  end)
end)

-- connect vpn
hs.hotkey.bind(hyperS, 'v', function()
  local app = 'bbvpn2'
  if hs.application.launchOrFocus(app) then
    local bbvpn = hs.application.get(app)
    bbvpn:selectMenuItem({ 'Action', 'Connect' })
  end
end)

-- start bba after vpn connected
hs.urlevent.bind('bbvpnConnected', function()
  hs.printf('bbvpn connected callback')
  if hs.application.get('Citrix Viewer') == nil then
    -- do this if citrix isnt running
    local firefox = hs.application.get('Firefox')
    firefox:activate()
    firefox:selectMenuItem({ 'Bookmarks', 'Bookmarks Toolbar', 'BBA' })
  end
end)

-- }}}

hs.alert.show('Loaded HammerSpoon Config')
