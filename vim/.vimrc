noremap <Space> <Nop>
map <Space> <Leader>

set nocp
set rnu
syntax on
set number
set tabstop=4
set smartindent
set autoindent
set shiftwidth=4
set showmatch
set matchtime=5
set cindent
set ignorecase smartcase " ignore case during searching, except that one or more capital letter exists
set laststatus=2 " show status bar
" set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\

" user directory var: $VIMFILES
let $VIMFILES = $HOME.'/.vim'
" set doc directory
let helptags=$VIMFILES.'/doc'

"Backspace should be configured for easy usage
" - indent: delete indent
" - eol: wrap two lines
" - start: delete previous input content
set backspace=indent,eol,start

"Highlight
set cursorline
hi CursorLine   cterm=NONE ctermbg=darkgray ctermfg=NONE
hi SpecialKey guifg=darkgrey ctermfg=darkgrey

"Vundle
set nocompatible        " be iMproved, required
filetype off            " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
    highlight! link SignColumn LineNr
    highlight GitGutterAdd    guifg=#009900 ctermfg=2
    highlight GitGutterChange guifg=#bbbb00 ctermfg=3
    highlight GitGutterDelete guifg=#ff2222 ctermfg=1
    let g:gitgutter_set_sign_backgrounds = 1
Plugin 'ervandew/supertab'
Plugin 'bkad/CamelCaseMotion'
    let g:camelcasemotion_key = '<leader>'
"TagList(ctags)
"Plugin 'vim-scripts/taglist.vim'
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
    let Tlist_Show_One_File = 1
    let Tlist_Exit_OnlyWindow = 1
    let Tlist_Auto_Open = 1
    let Tlist_Use_Right_Window = 0
    map <leader>tl :TlistToggle<CR>
"Cpp Highlight
Plugin 'octol/vim-cpp-enhanced-highlight'
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_posix_standard = 1
    let g:cpp_experimental_simple_template_highlight = 1
    let g:cpp_experimental_template_highlight = 1
    let g:cpp_concepts_highlight = 1
    let g:cpp_no_function_highlight = 1

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set tags=~/App-GB/tags_20231204

"YCM
let g:syntastic_python_python_exec = '/home/sdb/zhengcj/Python-3.6.7/install/bin/python3'·
let g:ycm_server_python_interpreter='/home/sdb/zhengcj/Python-3.6.7/install/bin/python3'
let g:ycm_python_sys_path = '/home/sdb/zhengcj/Python-3.6.7/install/lib/python3.6'
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
" make completion like other IDE (VimTip1228)
set completeopt=longest,menu
" close preview window when leaving insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" down, up action will trigger additional info
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" go to definition
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
"force recomile with syntastic
nnoremap <leader>rd :YcmForceCompileAndDiagnostics<CR>
"open locationlist
nnoremap <leader>lo :lopen<CR>
"close locationlist
nnoremap <leader>lc :lclose<CR>
" don't show check information of ycm_extra_conf.py file
let g:ycm_confirm_extra_conf=0
" completion based on tags
let g:ycm_collect_identifiers_from_tags_files=1
" completion also used in comment and string
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
" start completion from second character
let g:ycm_min_num_of_chars_for_completion=2
" disable cache
let g:ycm_cache_omnifunc=0
" semantic completion
let g:ycm_seed_identifiers_with_syntax=1
" disable ycm on such filetype
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'nerdtree' : 1,
      \}
" next/previous selecton
let g:ycm_key_list_select_completion = ['<C-n>']
let g:ycm_key_list_previous_completion = ['<C-p>']
highlight Pmenu ctermfg=4 ctermbg=7 guifg=#ffffff guibg=#000000
