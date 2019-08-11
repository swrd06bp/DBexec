nnoremap <localleader>d : call RunSQLFile()<cr>


function! GetDBCmd()
  " recreate the linux command
  let l:cmd = 'PGPASSWORD='. get(g:creds, g:DBexec).password . ' psql -h ' . get(g:creds, g:DBexec).hostname . ' -d ' . get(g:creds, g:DBexec).database . ' -U ' . get(g:creds, g:DBexec).username . ' -f ' . expand('%')
  
  return l:cmd
endfunction


function! RunSQLFile()
  " Get psql command with credentials
  let l:cmd = GetDBCmd()
  let l:results = systemlist(l:cmd)

  " Create a split with a meaningful name
  let l:name = '__SQL_Results__'

  if bufwinnr(l:name) > -1 &&  expand('%:t') == l:name
    " quit existing window
    execute 'q!' 
  else
    if bufwinnr(l:name) > -1
      " Focus the existing window
      execute bufwinnr(l:name) . 'wincmd w'
    else
      " Open a new tab
      execute 'belowright split' . l:name
    endif

    " Clear out existing content
    normal! gg"_dG

    " Don't prompt to save the buffer
    set buftype=nofile


    " Insert the results.
    call append(0, l:results)
  endif

endfunction
