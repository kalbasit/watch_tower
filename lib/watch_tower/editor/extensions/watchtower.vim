" This function prints the list of open files
" Usage:
" vim --servername "<server>" --remote-expr "watchtower#ls()"

" Make sure the function is loaded only once
if exists("loaded_watchtower_ls_function")
  finish
endif
let loaded_watchtower_ls_function = 1

" Provided by Marcin Szamotulski <mszamot@gmail.com>
" Modified by Wael Nasreddine <wael.nasreddine@gmail.com>
" http://groups.google.com/group/vim_use/msg/3dfb796c366b2e50
function! watchtower#ls()
  let list=[]
  for i in range(1, bufnr('$'))
    call add(list, fnamemodify(bufname(i), ':p'))
  endfor
  return list
endfunction
