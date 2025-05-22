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
hs.alert.show('Loading HammerSpoon Config')
modealerts = {}
function makeMode(mods, key, name)
  local mode = hs.hotkey.modal.new(mods, key)
  function mode:entered()
    modealerts[name] = hs.alert.show(name, hs.alert.defaultStyle, hs.screen.mainScreen(), 'indefinite')
  end

  function mode:exited()
    hs.alert.closeSpecific(modealerts[name])
  end

  -- bind to key to hyper and without modifiers
  -- purpose of binding to hyper is to make it optional
  -- to release hyper when executing the hotkey
  function mode:hyperBind(key, fn)
    local function fnWithExit()
      fn()
      mode:exit()
    end
    mode:bind('', key, fnWithExit)
    mode:bind(hyper, key, fnWithExit)
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
  window = marks[mark]
  if window then
    -- window:focus()
    hs.execute('aerospace focus --window-id ' .. window:id(), true)
  else
    hs.alert.show(string.format('no mark assigned to "%s"', mark))
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

focusMode = makeMode(hyper, '\'', 'focus mode')
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

local mainTerminalWindow = nil
local notesTerminalWindow = nil
termWf = hs.window.filter
  .new('kitty')
  :subscribe(hs.window.filter.windowAllowed, function(win)
    if win:title() == 'notes' then
      notesTerminalWindow = win
    else
      if mainTerminalWindow == nil then
        mainTerminalWindow = win
      end
    end
  end, true)
  :subscribe(hs.window.filter.windowDestroyed, function(win)
    if notesTerminalWindow ~= nil and win:id() == notesTerminalWindow:id() then
      notesTerminalWindow = nil
    elseif mainTerminalWindow ~= nil and win:id() == mainTerminalWindow:id() then
      mainTerminalWindow = nil
    end
  end)

-- Zoom Mode {{{
local zoomModeText = [[
Zoom Mode

Focus Zoom                = enter
Toggle Audio              = z
Toggle Video              = v
Toggle Chat               = c
Toggle Minimal View       = m
Leave Meeting             = x
Pause/Resume Screen Share = p
Start/Stop Screen Share   = s
Copy Invite Link          = i ]]
local zoomMode = makeMode(hyper, 'z', zoomModeText)

zoomMode:hyperBind('return', function()
  hs.application.launchOrFocus('zoom.us')
end)

-- toggle audio mute
zoomMode:hyperBind('z', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Mute audio' }) then
      zoom:selectMenuItem({ 'Meeting', 'Mute audio' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Unmute audio' })
    end
  end
end)

-- toggle video on
zoomMode:hyperBind('v', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Start video' }) then
      zoom:selectMenuItem({ 'Meeting', 'Start video' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Stop video' })
    end
  end
end)

-- toggle minimal view

zoomMode:hyperBind('m', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Exit minimal view' }) then
      zoom:selectMenuItem({ 'Meeting', 'Exit minimal view' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Enter minimal view' })
    end
  end
end)

zoomMode:hyperBind('i', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    zoom:selectMenuItem({ 'Meeting', 'Copy invite link' })
  end
end)

zoomMode:hyperBind('x', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Exit minimal view' }) then
      zoom:selectMenuItem({ 'Meeting', 'Exit minimal view' })
    end
    zoom:activate()
    hs.eventtap.keyStroke({ 'cmd' }, 'w')
  end
end)

zoomMode:hyperBind('p', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Pause share' }) then
      zoom:selectMenuItem({ 'Meeting', 'Pause share' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Resume share' })
    end
  end
end)

zoomMode:hyperBind('s', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'Meeting', 'Stop share' }) then
      zoom:selectMenuItem({ 'Meeting', 'Stop share' })
    else
      zoom:selectMenuItem({ 'Meeting', 'Start share' })
    end
  end
end)

zoomMode:hyperBind('c', function()
  local zoom = hs.application.get('zoom.us')
  if zoom ~= nil then
    if zoom:findMenuItem({ 'View', 'Show chat' }) then
      zoom:selectMenuItem({ 'View', 'Show chat' })
    else
      zoom:selectMenuItem({ 'View', 'Close chat' })
    end
  end
end)
-- }}}

-- Browser Mode {{{

local browserModeText = [[
Browser Mode

Focus Browser    = enter
Search Bookmarks = b
Search Tabs      = t
Search idk       = i
Meetings         = m
Open ChatGPT     = c]]
local browserMode = makeMode(hyper, 'b', browserModeText)

browserMode:hyperBind('return', function()
  hs.application.launchOrFocus('Firefox')
end)

-- search bookmarks in firefox
browserMode:hyperBind('b', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  firefox:selectMenuItem({ 'Bookmarks', 'Search Bookmarks' })
end)

hs.hotkey.bind(hyper, 'u', function()
  output, status, exit_type, rc = hs.execute('/Users/friaz10/inbox/ffbookmarks.sh', true)
  hs.printf('output: %s, rc: %d', output, rc)
  if status then
    local firefox = hs.application.get('Firefox')
    firefox:activate()
  end
end)

-- search tabs in firefox
browserMode:hyperBind('t', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  --hs.eventtap.keyStroke({'cmd'}, "l")
  hs.eventtap.keyStrokes('@tabs ')
end)

browserMode:hyperBind('n', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  hs.eventtap.keyStroke({ 'ctrl' }, 2, 50000)
  firefox:selectMenuItem({ 'File', 'New Tab' })
end)

-- search pull request tabs in firefox
browserMode:hyperBind('p', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  --hs.eventtap.keyStroke({'cmd'}, "l")
  hs.eventtap.keyStrokes('@tabs pull ')
end)

-- go to chatgpt
browserMode:hyperBind('c', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
end)

-- search idk
browserMode:hyperBind('i', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  firefox:selectMenuItem({ 'Bookmarks', 'Bookmarks Toolbar', 'idk' })
end)

browserMode:hyperBind('m', function()
  local firefox = hs.application.get('Firefox')
  firefox:activate()
  firefox:selectMenuItem({ 'File', 'New Tab' })
  firefox:selectMenuItem({ 'Bookmarks', 'Other Bookmarks', 'Meetings' })
end)
-- }}}

-- Terminal Mode {{{
local terminalModeText = [[
Terminal Mode

Focus Terminal       = enter
Dotfiles Session     = d
Tmux T Session       = t
Tmux B Session       = b
Tmux Active Mark     = a
Tmux Floating Window = f
Open Session         = o ]]
local terminalMode = makeMode(hyper, 't', terminalModeText)

terminalMode:hyperBind('return', function()
  if mainTerminalWindow == nil then
    hs.application.launchOrFocus('kitty')
    return
  end
  mainTerminalWindow:focus()
end)

terminalMode:hyperBind('d', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'd', 50000)
end)

terminalMode:hyperBind('t', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 't', 50000)
end)

terminalMode:hyperBind('b', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'b', 50000)
end)

terminalMode:hyperBind('o', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'o', 50000)
end)

terminalMode:hyperBind('a', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'alt' }, 'm', 50000)
end)

terminalMode:hyperBind('f', function()
  if mainTerminalWindow == nil then
    return
  end
  mainTerminalWindow:focus()
  hs.eventtap.keyStroke({ 'cmd' }, '1', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 's', 50000)
  hs.eventtap.keyStroke({ 'ctrl' }, 'f', 50000)
end)

-- }}}

-- Notes Mode {{{
local notesModeText = [[
Notes Mode

Focus notes   = enter
Daily Note    = n
Open Note     = o
Reference     = r
BBG Functions = b
Harpoon <Num> = <num>]]
local notesMode = makeMode(hyper, 'n', notesModeText)
notesMode:hyperBind('return', function()
  if notesTerminalWindow == nil then
    hs.execute('${HOME}/.local/bin/launch-notes.sh', true)
    return
  end
  notesTerminalWindow:focus()
end)

notesMode:hyperBind('n', function()
  if notesTerminalWindow == nil then
    return
  end
  notesTerminalWindow:focus()
  local app = notesTerminalWindow:application()
  hs.eventtap.keyStroke({ 'ctrl' }, 'c', nil, app) -- go to normal mode if not in it
  hs.eventtap.keyStrokes(',Ed', app)
end)

notesMode:hyperBind('r', function()
  if notesTerminalWindow == nil then
    return
  end
  notesTerminalWindow:focus()
  hs.eventtap.keyStrokes(' h1')
end)

notesMode:hyperBind('b', function()
  if notesTerminalWindow == nil then
    return
  end
  notesTerminalWindow:focus()
  hs.eventtap.keyStrokes(' h2')
end)

notesMode:hyperBind('o', function()
  if notesTerminalWindow == nil then
    return
  end
  notesTerminalWindow:focus()
  hs.eventtap.keyStrokes(' o')
end)

for i = 1,9 do
  notesMode:hyperBind(tostring(i), function()
    if notesTerminalWindow == nil then
      return
    end
    notesTerminalWindow:focus()
    hs.eventtap.keyStrokes(' h' .. i)
  end)
end


-- }}}

-- -- write out clipboard
-- -- use this to type out the clipboard
-- -- useful for when you cant paste into an application
-- -- like a VDI
-- hs.hotkey.bind(hyper, 'v', function()
--   local clipboardContents = hs.pasteboard.getContents()
--   if clipboardContents == nil then
--     hs.alert.show('nil or invalid clipboard')
--     return
--   end
--
--   hs.timer.doAfter(1, function()
--     hs.eventtap.keyStrokes(clipboardContents)
--   end)
-- end)

-- connect vpn
hs.hotkey.bind(hyperS, 'v', function()
  local app = 'bbvpn2'
  if hs.application.launchOrFocus(app) then
    local bbvpn = hs.application.get(app)
    bbvpn:selectMenuItem({ 'Action', 'Connect' })
  end
end)

-- }}}

hs.alert.show('Finished Loading HammerSpoon Config')
