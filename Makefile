# Simple makefile to install all files and backup copies which are about to be overwritten
DATE=$(shell date +'%C%y%m%d_%H%M%S')

define CP
	install -m $2 --backup --compare --suffix="~$(DATE)" "$1" "$(HOME)/.$1"
endef

define CLEAN
	rm "$(HOME)/.$1"~*_* &> /dev/null || true
endef

.PHONY: install clean git shell vim x11 gitc shellc vimc x11c

install: git shell vim x11

clean: gitc shellc vimc x11c

git:
	$(call CP,gitconfig,0640)
	$(call CP,gitk,0640)
	$(call CP,gitignore_global,0640)

gitc:
	$(call CLEAN,gitconfig)
	$(call CLEAN,gitk)
	$(call CLEAN,gitignore_global)

shell:
	$(call CP,bashrc,0644)
	$(call CP,bash_aliases,0644)
	$(call CP,bash_completion.maven,0644)
	$(call CP,bash_logout,0644)
	$(call CP,bash_profile,0644)
	$(call CP,inputrc,0644)
	$(call CP,sshrc,0644)
	wget -q -nc \
		"https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark" \
		-O "$(HOME)/.dircolors" || echo -n
	wget -q -nc \
		"https://raw.githubusercontent.com/juven/maven-bash-completion/master/bash_completion.bash" \
		-O "$(HOME)/.bash_completion.maven" || echo -n

shellc:
	$(call CLEAN,bashrc)
	$(call CLEAN,bash_aliases)
	$(call CLEAN,bash_completion.maven)
	$(call CLEAN,bash_logout)
	$(call CLEAN,bash_profile)
	$(call CLEAN,inputrc)
	$(call CLEAN,sshrc)

vim:
	mkdir -p "$(HOME)/.vim/doc" &> /dev/null
	mkdir -p "$(HOME)/.vim/syntax" &> /dev/null
	$(call CP,vimrc,0644)
	$(call CP,vim/filetype.vim,0644)
	$(call CP,vim/doc/hell.txt,0644)
	$(call CP,vim/doc/tags,0644)
	$(call CP,vim/syntax/orcconf.vim,0644)
	if ! [ -d "$(HOME)/.vim/bundle/Vundle.vim" ]; then \
		mkdir -p "$(HOME)/.vim/bundle" &> /dev/null; \
		git clone https://github.com/VundleVim/Vundle.vim.git "$(HOME)/.vim/bundle/Vundle.vim"; \
	fi
	if command -v vim &> /dev/null; then \
		vim +PluginInstall +qall; \
	fi; \

# TODO - Compile YouCompleteMe and VimShell?
vimc:
	$(call CLEAN,vimrc)
	$(call CLEAN,vim/filetype.vim)
	$(call CLEAN,vim/doc/hell.txt)
	$(call CLEAN,vim/doc/tags)
	$(call CLEAN,vim/syntax/orcconf.vim)

x11:
	$(call CP,inputrc,0644)
	$(call CP,xinitrc,0644)
	$(call CP,Xdefaults,0644)
# This is a trick to copy the existing file (the same as the others
# before deleting the 2nd Xdefaults and making it a symlink
	if ! [ -L "$(HOME)/.Xresources" ]; then \
		install -m 0644 --backup --suffix="~$(DATE)" Xresources "$(HOME)/.Xdefaults"; \
		rm "$(HOME)/.Xresources"; \
		ln -s "$(HOME)/.Xdefaults" "$(HOME)/.Xresources"; \
	fi

	if command -v gsettings &> /dev/null; then \
		gsettings set org.gnome.desktop.wm.preferences audible-bell false; \
	fi; \
	if command -v urxvtd &> /dev/null; then \
		if command -v systemctl &> /dev/null; then \
			mkdir -p "$(HOME)/.config/systemd/user" &> /dev/null; \
			install -m 0644 --backup --compare --suffix="~$(DATE)" config/systemd/user/urxvtd.* "$(HOME)/.config/systemd/user"; \
			if ! systemctl --user is-enabled urxvtd.service &> /dev/null; then \
				systemctl --user enable urxvtd.service; \
			fi; \
			if ! systemctl --user is-active urxvtd.service &> /dev/null; then \
				systemctl --user start urxvtd.service; \
			fi; \
		fi; \
	fi

x11c:
	$(call CLEAN,inputrc)
	$(call CLEAN,xinitrc)
	$(call CLEAN,Xresources)
	$(call CLEAN,Xdefaults)
	rm "$(HOME)/.config/systemd/user/urxvtd."*~*_* &> /dev/null || true

