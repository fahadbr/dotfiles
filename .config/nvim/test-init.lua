local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt


opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.nowrap = true
opt.nohlsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.incsearch = true
opt.showmatch = true
opt.cursorline = true
opt.mouse += 'a'
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.linebreak = true
opt.title = true
opt.ruler = true
opt.undolevels = 1000
opt.backspace = 'indent,eol,start'
opt.autoread = true
opt.grepprg = 'rg --vimgrep'
opt.inccommand = 'nosplit'

