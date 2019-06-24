let @i='import IPython; IPython.embed(); exit()'
let @p='import ipdb; ipdb.set_trace()'
set nowrap

" Set up auto formatting
if executable('black')
    nnoremap <leader>y mm:%!black --fast -q -<Cr>`m
endif
