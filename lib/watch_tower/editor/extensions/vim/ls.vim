" This function prints the list of open files
" Usage:
" vim --servername "<server>" --remote-expr "vim#ls()"
" Provided by Marcin Szamotulski <mszamot@gmail.com>
" http://groups.google.com/group/vim_use/msg/3dfb796c366b2e50

if exists("loaded_vim_ls_function")
  finish
endif
let loaded_vim_ls_function = 1

function! vim#ls()
  let list=[]
  for i in range(1, bufnr('$'))
    call add(list, ( bufloaded(i) ? "(".i.") " . fnamemodify(bufname(i), ':p') : "  ". fnamemodify(:bufname(i), ':p')))
  endfor
  return list
endfunction
