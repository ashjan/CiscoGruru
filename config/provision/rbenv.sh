#!/bin/bash

set -e

function install_rbenv() {
	if [ -d /home/webapp/.rbenv ]; then
		echo "rbenv already installed, skipping..."
	else
		git clone https://github.com/sstephenson/rbenv.git /home/webapp/.rbenv
	fi
}

function modify_profile() {
	if [ -f /home/webapp/.bash_profile ]; then
		if grep -q rbenv '/home/webapp/.bash_profile'; then
			echo "profile already modified, skipping..."
			return
		fi
	fi
	echo 'adding rbenv to bash_profile...'
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/webapp/.bash_profile
	echo 'eval "$(rbenv init -)"' >> /home/webapp/.bash_profile
	source /home/webapp/.bash_profile
}

function install_rubybuild() {
	if [ -d /home/webapp/.rbenv/plugins/ruby-build ]; then
		echo "ruby-build already installed, skipping..."
	else
		source /home/webapp/.bash_profile
		git clone https://github.com/sstephenson/ruby-build.git /home/webapp/.rbenv/plugins/ruby-build
		rbenv install 2.2.0
		rbenv rehash
		if [ ! -f /home/webapp/.gemrc ]; then
			echo "gem: --no-ri --no-rdoc" >> /home/webapp/.gemrc
		fi
	fi
}

install_rbenv
modify_profile
install_rubybuild

