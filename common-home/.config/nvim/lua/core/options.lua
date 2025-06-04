local function autocmd(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

vim.g.mapleader = ','
vim.g.maplocalleader = '-'

if fr.in_ssh then
  vim.g.clipboard = 'osc52'
end

vim.o.number = true
vim.o.relativenumber = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.showmatch = true
vim.o.cursorline = true
vim.o.hidden = true
vim.o.linebreak = true
vim.o.title = true
vim.o.ruler = true
vim.o.autoread = true
vim.o.termguicolors = true
vim.o.mousemoveevent = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.signcolumn = 'yes'
vim.o.undolevels = 1000
vim.o.grepprg = 'rg --vimgrep --hidden --smart-case'
vim.o.inccommand = 'nosplit'
vim.o.background = 'dark'
vim.o.completeopt = 'menuone,noselect'

-- use vim.opt instead of vim.o when accessing
-- or modifying options in as a table/list
-- see :h vim.opt
vim.opt.mouse:append('a')
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.sessionoptions:remove { 'blank' }
vim.opt.sessionoptions:append { 'globals' }

autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = { '*' },
  command = 'checktime'
})
autocmd({ 'Filetype' }, {
  pattern = { 'markdown' },
  callback = function(opts) vim.bo[opts.buf].textwidth = 120 end
})

autocmd('TextYankPost', {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 250 })
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
})

