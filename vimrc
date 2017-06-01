set nocompatible              " required
filetype off                  " required

" for installing vundle:
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'jpalardy/vim-slime'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'terryma/vim-smooth-scroll'
Bundle 'tpope/vim-surround'
Bundle 'easymotion/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Plugin 'rbong/vim-vertical'
" Make sure to call :PluginInstall in vim after changing the list


" For YouCompleteMe, you must install afterwards:
" cd ~/.vim/bundle/YouCompleteMe
" ./install.py --clang-completer
" or on ubuntu 16:
" python3 ./install.py --clang-completer

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)


" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on    " requiredenable syntax highlighting


"Standard configuration


" escaping
" using using jk 
inoremap jk <esc>
inoremap kj <esc>
" or tab
nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
inoremap <Tab> <Esc>`^
inoremap <Leader><Tab> <Tab>

syntax enable

:let mapleader=" "

" encoding
set encoding=utf-8

" show line numbers
set number

" set tabs to have 4 spaces
set ts=4

" indent when moving to the next line while writing code
set autoindent

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" show a visual line under the cursor's current line 
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" Ignore case for seaches
" set ignorecase


set expandtab
set tabstop=4
set shiftwidth=4
map <F2> :retab <CR> :wq! <CR>

"Remap change split screen
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" shortcut for changing tab
nnoremap L gt
nnoremap H gT
" nnoremap > gt
" nnoremap < gT


au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set nowrap |


" syntastic
set laststatus=2
let g:syntastic_python_checkers = ['pylint']
" make sure pylint is installed in the virtualenv you use!


" configuration for nerdtree
" active tree shortcut
map <C-n> :NERDTreeToggle<CR>
" ignore tree if it is the last left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']


" clipboard from extern applications
set clipboard=unnamed





"python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(open(activate_this).read(), dict(__file__=activate_this))
EOF




" Make UltiSnips compatible with YouCompleteMe
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction


" Configurations for autocomplete bundle
" only for specific files
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1 }
" autoclose and go to definition
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" do not forget to have leader defined
let g:ycm_server_python_interpreter = '/usr/bin/python3'



" slime for sending code to ipython
let g:slime_python_ipython = 1
let g:slime_target = "tmux"
let g:slimux_select_from_current_window = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.1"}
let g:slime_dont_ask_default = 1
" use with tmux! or byobu
" select second pane of current window with 0.1
" useful commands:
" byobu -L <session> attach
" tmux new -s p3
" tmux attach -t p3

" for restarting ipython on left panel:
" (silent execution requires redrawing afterwards)
command IPyRestart silent execute "!byobu-tmux send-keys -t right 'exit' enter C-l && byobu-tmux send-keys -t right 'ipython' enter C-l" | execute ':redraw!'
map <F10> :IPyRestart<CR>


" solarize (color pattern)
let g:solarized_termtrans = 1
colorscheme solarized 
syntax enable
set background=dark
hi LineNr ctermfg=DarkGrey guifg=#2b506e guibg=#000000


" CtrlP for opening files easily
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_user_command = ['.git/', 'git ls-files --cached --others  --exclude-standard %s']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
" use ctrl+t to open in a new tab


" fast and smooth movements
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>


" ZSH like menu
" When you type the first tab, it will complete as much as possible,
" the second tab hit will provide a list, the third
" and subsequent tabs will cycle through completion options
" so you can complete the file without further keys
set wildmode=longest,list,full
" Sweet zsh-like autocompletion menu
set wildmenu

" vertically look for non-empty character
" map <leader>j :Vertical f<CR>
" map <leader>k :Vertical b<CR>
noremap <silent> <c-j> :Vertical f<CR>
noremap <silent> <c-k> :Vertical b<CR>

" set paste mode
set pastetoggle=<F12>

" caps lock as esc
au VimEnter * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

" go to end of copy after copying
vnoremap y y']
vnoremap Y y

" Colorize line numbers in insert and visual modes
" ------------------------------------------------
function! SetCursorLineNrColorInsert(mode)
    " Insert mode: white
    if a:mode == "i"
        highlight CursorLineNr ctermfg=9 
        highlight LineNr ctermfg=9
    " Replace mode: red
    elseif a:mode == "r"
        highlight CursorLineNr ctermfg=1
        highlight LineNr ctermfg=1
    endif
endfunction

function! SetCursorLineNrColorVisual()
    set updatetime=0
    " Visual mode: green
    highlight CursorLineNr cterm=none ctermfg=2
    highlight LineNr cterm=none ctermfg=2
endfunction

function! SetCursorLineNrColorReplace()
    set updatetime=0
    " Replace mode: red
    highlight CursorLineNr cterm=none ctermfg=1
    highlight LineNr cterm=none ctermfg=1
endfunction

function! SetCursorLineNrColorScript()
    set updatetime=0
    " script mode: blue
    highlight CursorLineNr cterm=none ctermfg=4
    highlight LineNr cterm=none ctermfg=4
endfunction

function! ResetCursorLineNrColor()
    set updatetime=4000
    highlight CursorLineNr cterm=none ctermfg=3
    highlight LineNr cterm=none ctermfg=3
endfunction


nnoremap <silent> v :call SetCursorLineNrColorVisual()<CR>v
nnoremap <silent> V :call SetCursorLineNrColorVisual()<CR>V
nnoremap <silent> <C-v> :call SetCursorLineNrColorVisual()<CR><C-v>
nnoremap <silent> g :call SetCursorLineNrColorReplace()<CR>r
nnoremap , :call SetCursorLineNrColorScript()<CR>:
nnoremap / :call SetCursorLineNrColorScript()<CR>/

augroup CursorLineNrColorSwap
    autocmd!
    autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
    autocmd InsertLeave * call ResetCursorLineNrColor()
    autocmd CursorHold * call ResetCursorLineNrColor()
augroup END
