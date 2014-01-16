" Global setup {{{
" -------------
" Nice vundle stuff
filetype off


" Automatically install vundle
let s:VundleInstalled = 1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !git clone git://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let s:VundleInstalled = 0
endif

let g:vundle_default_git_proto = 'git'

" Handle vundle here
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

"}}}
" Let vundle manage vundle
Bundle 'gmarik/vundle'

" tpope plugins, these deserve their own section
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-markdown'
" Bundle 'tpope/vim-vinegar'

" Custom plugins
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'rking/ag.vim'
Bundle 'nelstrom/vim-markdown-folding'

" My plugins or forks
Bundle 'mindriot101/srw-colorscheme.vim'

" Snipmate plugins
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'

"{{{ Post-setup
filetype plugin indent on

if s:VundleInstalled == 0
    echo "Installing bundles"
    echo ""
    :BundleInstall
endif
"}}}
" vim: foldmethod=marker
