#!/bin/bash

#
# Automatically install/setup MacVim and Vim plugins
#

file_not_contains() {
  keyword=$1
  file=$2
  lines=`cat $file | grep -w "$keyword" | wc -l`
  [ $lines -le 0 ]
}

Platform=`uname`
bashrc=$HOME/.bashrc
vimbundle=$HOME/.vim/bundle
vimautoload=$HOME/.vim/autoload

# Update .vimrc
if [ -e ./vimrc ]; then
  cp ./vimrc ~/.vimrc
else
  curl -LSso ~/.vimrc https://github.com/bo-yang/vim_config/blob/master/vimrc
fi

# Install Pathogen, link https://github.com/tpope/vim-pathogen
mkdir -p $vimautoload $vimbundle && \
curl -LSso $vimautoload/pathogen.vim https://tpo.pe/pathogen.vim

# Config ctags
if [[ "$Platform" == 'Darwin' ]]; then
  # Install Exuberant Ctags
  brew install ctags
  if [ ! -e /usr/local/bin/ctags ]; then
    echo "Error: failed to install Exuberant Ctags!"
  fi
  # Set the path of ctags in bashrc, which is used in vimrc
  if `file_not_contains "export CTAGS_BIN" $bashrc`; then
    echo "export CTAGS_BIN=/usr/local/bin/ctags" >> $bashrc
  fi
else
    # Linux ctags should be Exuberant Ctags by default
    local ctag=$(which ctags)
    if [ "$ctag" == "" ]; then
        local installer=$(which yum)
        if [ "$installer" == "" ]; then
            installer=$(which apt-get)
        fi
        echo ""
        echo "ctags not found, installing it using $installer ...."
        sudo $installer install ctags
        echo ""
    fi
fi
# cscope key mapping
mkdir -p ~/.vim/plugin/
cp cscope_maps.vim ~/.vim/plugin/

# Install Tagbar
git clone https://github.com/majutsushi/tagbar.git $vimbundle/tagbar

# Install NERDTree & NERDTreeTabs
git clone https://github.com/scrooloose/nerdtree.git $vimbundle/nerdtree
git clone https://github.com/jistr/vim-nerdtree-tabs.git $vimbundle/vim-nerdtree-tabs

# Install SuperTab
git clone https://github.com/ervandew/supertab.git $vimbundle/supertab

# Install CtrlP & Command-T
# TODO: very slow, ignore it for now.

# Install Fugitive
git clone https://github.com/tpope/vim-fugitive.git $vimbundle/vim-fugitive
vim -u NONE -c "helptags vim-fugitive/doc" -c q

# C++11 Syntax
git clone https://github.com/octol/vim-cpp-enhanced-highlight.git /tmp/vim-cpp-enhanced-highlight
mkdir -p ~/.vim/after/syntax/
mv /tmp/vim-cpp-enhanced-highlight/after/syntax/cpp.vim ~/.vim/after/syntax/cpp.vim
rm -rf /tmp/vim-cpp-enhanced-highlight

# Go Syntax
git clone https://github.com/fatih/vim-go.git $vimbundle/vim-go

# Click Syntax
git clone https://github.com/mtahmed/click.vim.git $vimbundle/click.vim

# setup MacVim
if [[ "$Platform" == 'Darwin' ]]; then
  if [ ! -d /Applications/MacVim.app/Contents/MacOS/ ]; then
    echo "Cannot find MacVim on this computer. Skip setting mvim aliases."
    echo "Please download & install MacVim first, link https://github.com/macvim-dev/macvim/releases"
    exit 1
  fi

  # Add alias
  if `file_not_contains "alias mvim" $bashrc`; then
    echo "alias mvim='/Applications/MacVim.app/Contents/MacOS/MacVim'" >> $bashrc
  fi
  if `file_not_contains "alias mvimdiff" $bashrc`; then
    echo "alias mvimdiff='/Applications/MacVim.app/Contents/MacOS/MacVim -d'" >> $bashrc
  fi
  if `file_not_contains "alias gvim" $bashrc`; then
    echo "alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'" >> $bashrc
  fi
  if `file_not_contains "alias gvimdiff" $bashrc`; then
    echo "alias gvimdiff='/Applications/MacVim.app/Contents/MacOS/Vim -g -d'" >> $bashrc
  fi
fi
