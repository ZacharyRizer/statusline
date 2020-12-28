" un-modified colors
hi User1 guibg=#BD93F9 guifg=#282A36 gui=bold
hi User2 guibg=#282A36 guifg=#BD93F9 gui=bold
" modified colors
hi User3 guibg=#FF5555 guifg=#282A36 gui=bold
hi User4 guibg=#282A36 guifg=#FF5555 gui=bold
" colors for non-current window
hi NotModifiedNC guibg=#282A36 guifg=#6272A4 gui=bold
hi ModifiedNC guibg=#282A36 guifg=#FF5555 gui=bold


function! FileNames()
    let specialFileNames = {'help': 'Help ', 'startify': 'Startify ', 'undotree': 'UndoTree '}
    if (has_key(specialFileNames, &filetype))
        return specialFileNames[&filetype]
    else
        return @%
    endif
endfunction

function! GetGitInfo()
    let gitInfo = get(g:, 'coc_git_status', '')
    if (gitInfo != '')
        return ' '.gitInfo.' '
    else
        return gitInfo
    endif
endfunction

function! ActiveStatus()
    let statusline=""
    if (&filetype == 'startify' || &filetype == 'undotree' )
        let statusline.="%1*\ ﰆ\ %2*%1*\ %{FileNames()}%2*%="
    elseif (&filetype == 'help')
        let statusline.="%1*\ ﰆ\ %2*%1*\ %{FileNames()}%2*%=\ %3p%%\ 難\ %1*\ %2l/%L\ \ %2v\ "
    else
        if (&modified)
            let statusline.="%3*\ ﰆ\ %4*%{GetGitInfo()}%3*\ %<%{FileNames()}\ %4*"
            let statusline.="%=\ %{coc#status()}\ \ %3p%%\ 難\ %3*\ %2l/%L\ \ %2v\ "
        else 
            let statusline.="%1*\ ﰆ\ %2*%{GetGitInfo()}%1*\ %<%{FileNames()}\ %2*"
            let statusline.="%=\ %{coc#status()}\ \ %3p%%\ 難\ %1*\ %2l/%L\ \ %2v\ "
        endif
    endif
    return statusline
endfunction

function! InactiveStatus()
    let statusline="%#ModifiedNC#%{&modified? '███   '.FileNames().' ': ''}%*%#NotModifiedNC#%{&modified? '' : '███   '.FileNames().' '}"
    let statusline.="%=%#ModifiedNC#%{&modified? '███' : ''}%*%#NotModifiedNC#%{&modified? '': '███'}"
    return statusline
endfunction

augroup status
  autocmd!
  autocmd BufWinEnter,BufWrite,WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd BufWritePost * :CocCommand git.refresh
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END
