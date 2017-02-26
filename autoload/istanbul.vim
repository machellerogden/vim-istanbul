" to load json generate from : istabul report

if !has('python3')
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
    hi uncovered guifg=#752E2B guibg=#5F0000 ctermfg=204 ctermbg=52
    hi fstatno guifg=#383838 guibg=#FFC520  ctermfg=208 ctermbg=208
    hi covered guifg=#739255 guibg=#005F00 ctermfg=40 ctermbg=22
    hi branch_true guifg=#000000 guibg=#D7AF00 ctermfg=16 ctermbg=178
    hi branch_false guifg=#000000 guibg=#D7AF00 ctermfg=16 ctermbg=178
    sign define uncovered text=✘ texthl=uncovered
    sign define fstatno text=✘ texthl=fstatno
    sign define covered text=✔ texthl=covered
    sign define branch_true text=if texthl=branch_true
    sign define branch_false text=el texthl=branch_false
endfunction

fun! s:istanbulShow() "{{{
    call s:SetHighlight()
    " if report not exists : istabul report
    exe 'py3 g_coverage_json_path = "' . g:coverage_json_path . '"'
    exe 'py3file ' . s:plugin_path . '/istanbul.py'
    python3 sign_covered_lines()
endf "}}}

fun! istanbul#IstanbulShow() "{{{
    call s:istanbulShow()
endf "}}}

fun! istanbul#IstanbulHide() "{{{
    call s:ClearSigns()
endf "}}}
