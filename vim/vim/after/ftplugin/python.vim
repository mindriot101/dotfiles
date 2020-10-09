let @i='import IPython; IPython.embed(); exit()'
let @p='import pudb; pudb.set_trace()'
let @n='if __name__ == "__main__":'
setlocal nowrap
setlocal textwidth=0

vnoremap <silent> <leader>t :VtrSendLinesToRunner<Cr>
nnoremap <silent> <leader>p vip:VtrSendLinesToRunner<Cr>

let b:ale_fixers = ["black"]
let b:ale_linters = ["flake8", "mypy"]

" override the pytest executable as pytest tries to be too clever when a
" Pipfile exists
let test#python#pytest#executable = 'pytest'
