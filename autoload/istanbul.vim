" to load json generate from : istabul report

if !has('python')
    echohl WarningMsg|echomsg "python interface to vim not found."
    finish
endif

if !exists('g:coverage_json_path')
    let json_path=getcwd().'/coverage/coverage.json'
    if filereadable(json_path)
        let g:coverage_json_path=json_path
    else
        echohl WarningMsg|echomsg "coverage.json file not found."
        finish
    end
end

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

function! s:ClearSigns() abort
    exe ":sign unplace *"
endfunction

function! s:SetHighlight()
    hi clear SignColumn
    hi link SignColumn Normal
    hi uncovered guifg=#752E2B guibg=#AB4642 ctermfg=196 ctermbg=196
    hi fstatno guifg=#383838 guibg=#ffc520  ctermfg=208 ctermbg=208
    hi covered guifg=#739255 guibg=#A1B56C ctermfg=40 ctermbg=106
    hi branch_true guifg=#383838 guibg=#F7CA88 ctermfg=16 ctermbg=226
    hi branch_false guifg=#383838 guibg=#F7CA88 ctermfg=16 ctermbg=226
    sign define uncovered text=✘ texthl=uncovered
    sign define fstatno text=✘ texthl=fstatno
    sign define covered text=✔ texthl=covered
    sign define branch_true text=if texthl=branch_true
    sign define branch_false text=el texthl=branch_false
endfunction

fun! s:istanbulShow() "{{{
    call s:SetHighlight()
    " if report not exists : istabul report
    exe 'py g_coverage_json_path = "' . g:coverage_json_path . '"'
    exe 'pyfile ' . s:plugin_path . '/istanbul.py'
    python sign_covered_lines()
endf "}}}

fun! istanbul#IstanbulShow() "{{{
    call s:istanbulShow()
endf "}}}

fun! istanbul#IstanbulHide() "{{{
    call s:ClearSigns()
endf "}}}
