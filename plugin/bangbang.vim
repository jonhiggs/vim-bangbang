let s:bangbangPrefix = "!!"
let s:bangbangSuffix = "¡¡"

function! s:BangBangWriteOut(start,end)
  call cursor(a:end[1],a:end[2])
  execute 'normal a' . s:bangbangSuffix

  call cursor(a:start[1],a:start[2])
  execute 'normal i' . s:bangbangPrefix
endfunction

function! BangBangNext()
  call search(s:bangbangPrefix . s:bangbangPrefix)
endfunction

function! BangBangPrevious()
  call search(s:bangbangPrefix . s:bangbangPrefix, 'b')
endfunction

function! BangBangParagraph()
  let l:starting_position = getcurpos()

  execute 'normal {j^'
  let l:start = getcurpos()

  execute 'normal }k$'
  let l:end = getcurpos()

  call s:BangBangWriteOut(l:start, l:end)
  call cursor(l:starting_position[1], l:starting_position[2])
endfunction

function! BangBangWord()
  let l:starting_position = getcurpos()

  execute 'normal B'
  let l:start = getcurpos()

  call cursor(l:starting_position[1], l:starting_position[2])
  execute 'normal E'
  let l:end = getcurpos()

  call s:BangBangWriteOut(l:start, l:end)

  call cursor(l:starting_position[1], l:starting_position[2])
endfunction

function! BangBangInside()
  let l:starting_position = getcurpos()
  call search(s:bangbangSuffix, 'Wz')
  let l:nextS = getcurpos()

  call cursor(l:starting_position[1], l:starting_position[2])
  call search(s:bangbangPrefix, 'Wz')
  let l:nextP = getcurpos()

  call cursor(l:starting_position[1], l:starting_position[2])

  if l:starting_position == l:nextS
    " there is no suffix after the cursor
    return 1
  endif

  if l:nextP[1] < l:nextS[1] && l:nextP[2] < l:nextS[2]
    " a prefix is coming before the next suffix
    return 1
  endif

  return 0
endfunction

function! BangBangDelete()
  if BangBangInside() != 0
    return 1
  endif

  let l:starting_position = getcurpos()
  call search(s:bangbangSuffix, 'Wz')
  execute 'normal xx'

  call cursor(l:starting_position[1], l:starting_position[2])

  let l:starting_position = getcurpos()
  call search(s:bangbangPrefix, 'bz')
  execute 'normal xx'

  call cursor(l:starting_position[1], l:starting_position[2])
  execute 'normal ll'
endfunction

map  !!    :call BangBangWord()<CR>
map  !ap   :call BangBangParagraph()<CR>
map  !d    :call BangBangDelete()<CR>
map  !n    :call BangBangNext()<CR>
map  !p    :call BangBangPrevious()<CR>
