return {
  { -- nerdtree
    'scrooloose/nerdtree',
    config = function()
      fr.nmap('<leader>nt', ':NERDTreeToggle<CR>', 'nerdtreetoggle')
      fr.nmap('<leader>nf', ':NERDTreeFind<CR>', 'nerdtreefind')
    end
  },
  {'Xuyuanp/nerdtree-git-plugin'},
  {'scrooloose/nerdcommenter'},
  { '.fzf',                    dev = true,   dir = "~" },
  {'junegunn/fzf.vim'},
  {'bronson/vim-trailing-whitespace'},
  { -- vim-sleuth
    'tpope/vim-sleuth',
    init = function() vim.g.sleuth_java_heuristics = 0 end,
    priority = 1000
  },
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'honza/vim-snippets'},
  { -- ReplaceWithRegister
    'inkarkat/vim-ReplaceWithRegister',
    init = function()
      fr.nmap('<leader>r', '<Plug>ReplaceWithRegisterOperator')
      fr.nmap('<leader>rr', '<Plug>ReplaceWithRegisterLine')
      fr.xmap('<leader>r', '<Plug>ReplaceWithRegisterVisual')
    end
  },
  {'AndrewRadev/splitjoin.vim'},
}
