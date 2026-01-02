let mapleader = " "
set autoindent
set clipboard+=unnamedplus
set ai ma si ts=2 sw=2
set undofile
set number
set completeopt=longest,menuone
set nobackup
set nowritebackup
set encoding=utf-8
set fileencoding=utf-8
set foldmethod=expr         
set foldlevelstart=99
set termguicolors
set expandtab
set updatetime=300
let g:transparent_enabled = v:true

"commmandopen vim config 
nmap<leader>cf :vsplit ~/.config/nvim/init.lua<cr>


"keymaps
nmap<leader>e :NERDTreeFind<CR>
nmap<leader>ff :FzfLua files <CR>
nmap<leader>fg :FzfLua grep_project<cr>
nmap<C-s> :w!<CR>
nmap<C-q> :bd<CR>
nmap<leader>vs :vsplit<CR>
nmap<S-h> :bprev<CR>
nmap<S-l> :bnext<CR>
nmap<leader>gs :FzfLua git_status<CR>
nmap<leader>gb :lua require('gitsigns').toggle_current_line_blame()<CR>
nmap<leader>ra :lua require('spectre').toggle()<CR>
nmap<leader>tr :TransparentToggle<CR>
