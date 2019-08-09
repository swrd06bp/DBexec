command! -nargs=+ DBexec : call RunSQLFile(<f-args>)



function! GetDBCmd(env)
  " recreate the linux command
  let l:cmd = 'PGPASSWORD='. g:creds.password . ' psql -h ' . g:creds.hostname . ' -d ' . g:creds.database . ' -U ' . g:creds.username . ' -f ' . expand('%')
  
  return l:cmd
endfunction


function! RunSQLFile(...)
  let l:env = a:000[0]
  " Get psql command with credentials
  let l:cmd = GetDBCmd(l:env)
  let l:results = systemlist(l:cmd)

  " Create a split with a meaningful name
  let l:name = '__SQL_Results__'

  if bufwinnr(l:name) == -1
    " Open a new tab
    execute 'tabnew ' . l:name
  else
    " Focus the existing window
    execute bufwinnr(l:name) . 'wincmd w'
  endif

  " Clear out existing content
  normal! gg"_dG

  " Don't prompt to save the buffer
  set buftype=nofile


  " Insert the results.
  call append(0, l:results)
endfunction
