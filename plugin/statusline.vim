hi User1 guibg=#BD93F9 guifg=#282A36 gui=bold
hi User2 guibg=#282A36 guifg=#BD93F9 gui=bold
hi User3 guibg=#343746 guifg=#282A36 gui=bold
hi User4 guibg=#343746 guifg=#F8F8F2 gui=bold 
" modified colors
hi User5 guibg=#FF5555 guifg=#282A36 gui=bold
hi User6 guibg=#282A36 guifg=#FF5555 gui=bold
hi User7 guibg=#6272A4 guifg=#282A36 gui=bold
hi User8 guibg=#6272A4 guifg=#F8F8F2 gui=bold 
" modified colors for inactive window
hi Modified guibg=#343746 guifg=#FF5555 gui=bold

function! FileNames()
    let specialFileNames = {'coc-explorer': 'Explorer ', 'help': 'Help ', 'startify': 'Startify ', 'undotree': 'UndoTree '}
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
    if (&filetype == 'coc-explorer' || &filetype == 'startify' || &filetype == 'undotree' )
        let statusline.="%1*\ ﰆ\ %2*\ %{FileNames()}%3*%4*%="
    elseif (&filetype == 'help')
        let statusline.="%1*\ ﰆ\ %2*\ %{FileNames()}%3*%4*%=%3*\ %2*%3p%%\ 難\ %1*\ %2l/%L\ \ %2v\ "
    else
        if (&modified)
            let statusline.="%5*\ ﰆ\ %6*%{GetGitInfo()}%7*%8*\ %<%{FileNames()}"
            let statusline.="%=\ %{coc#status()}\ %7*\ %6*%3p%%\ 難\ %5*\ %2l/%L\ \ %2v\ "
        else 
            let statusline.="%1*\ ﰆ\ %2*%{GetGitInfo()}%3*%4*\ %<%{FileNames()}"
            let statusline.="%=\ %{coc#status()}\ %3*\ %2*%3p%%\ 難\ %1*\ %2l/%L\ \ %2v\ "
        endif
    endif
    return statusline
endfunction

function! InactiveStatus()
    let statusline="%#Modified#%{&modified? '█   '.FileNames().' ': ''}%*%#StatusLineNC#%{&modified? '' : '█   '.FileNames().' '}"
    let statusline.="%=%#Modified#%{&modified? '█' : ''}%*%#StatusLineNC#%{&modified? '': '█'}"
    return statusline
endfunction

augroup status
  autocmd!
  autocmd BufWinEnter,BufWrite,WinEnter * setlocal statusline=%!ActiveStatus()
  autocmd WinLeave * setlocal statusline=%!InactiveStatus()
augroup END
