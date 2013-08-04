setlocal foldmethod=marker
setlocal iskeyword+=:
setlocal sw=2
setlocal wrap
setlocal nolist
setlocal spell
setlocal linebreak
setlocal nonumber
setlocal norelativenumber
setlocal cc=0
setlocal nocursorcolumn
setlocal conceallevel=0

" Synctex in skim
if has("gui_running")
    map <silent> <Leader>ls :silent !/Applications/Skim.app/Contents/SharedSupport/displayline -b -g <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>
else
    map <silent> <Leader>ls :!/Applications/Skim.app/Contents/SharedSupport/displayline -b -g <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>" "%:p" <CR>
endif
