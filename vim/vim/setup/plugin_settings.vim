" Enable matchit
runtime macros/matchit.vim

" Snipmate settings - use Ctrl-J for completion
imap <c-j> <Plug>snipMateNextOrTrigger
smap <c-j> <Plug>snipMateNextOrTrigger

" Fugitive mappings
nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gsd :Gsdiff<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gr :Gread<cr>
nmap <leader>gl :Glog<cr>

" Ctrl-p settings
let g:ctrlp_map = "<leader>f"
let g:ctrlp_cmd = "CtrlPMixed"

" Set colour scheme
set background=dark
colorscheme srw
