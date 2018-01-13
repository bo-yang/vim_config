#!/bin/sh

#
# Automatically install/setup MacVim and Vim plugins
#

# Install MacVim - manual work
if [ ! -d /Applications/MacVim.app/Contents/MacOS/ ]; then
  echo "Please download & install MacVim first, link https://github.com/macvim-dev/macvim/releases"
  exit 1
fi

file_not_contains() {
  keyword=$1
  file=$2
  lines=`cat $file | grep -w "$keyword" | wc -l`
  [ $lines -le 0 ]
}

# Add alias
bashrc=$HOME/.bashrc
if `file_not_contains "alias mvim" $bashrc`; then
  echo "alias mvim='/Applications/MacVim.app/Contents/MacOS/MacVim'" >> $bashrc
fi
if `file_not_contains "alias mvimdiff" $bashrc`; then
  echo "alias mvimdiff='/Applications/MacVim.app/Contents/MacOS/MacVim'" >> $bashrc
fi
if `file_not_contains "alias gvim" $bashrc`; then
  echo "alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'" >> $bashrc
fi
if `file_not_contains "alias gvimdiff" $bashrc`; then
  echo "alias gvimdiff='/Applications/MacVim.app/Contents/MacOS/Vim -g'" >> $bashrc
fi

# Download .vimrc
#TODO

# Install Pathogen, link https://github.com/tpope/vim-pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install Exuberant Ctags
brew install ctags
if [ ! -e /usr/local/bin/ctags ]; then
  echo "Error: failed to install Exuberant Ctags"
fi
# Set the path of ctags in bashrc, which is used in vimrc
if `file_not_contains "export CTAGS_BIN" $bashrc`; then
  echo "export CTAGS_BIN=/usr/local/bin/ctags" >> $bashrc
fi

vimbundle=$HOME/.vim/bundle
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
