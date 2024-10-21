O = out
.PHONY: all install uninstall install-dependence pack-deb

PREFIX = $(shell echo $$PREFIX)

all:
	@echo "Available commands:"
	@echo "make install : Install directly to your termux"
	@echo "make uninstall : Uninstall from your termux"
	@echo "make install-dependence : Install needed dependencies"
	@echo "make pack-deb : Build deb package"

install:
	cp ./src/lkm $(PREFIX)/bin
	cp ./src/light-sudo $(PREFIX)/bin
	mkdir -p $(PREFIX)/share/LKM-kernel
	cp -r ./share/* $(PREFIX)/share/LKM-kernel
	chmod +x $(PREFIX)/bin/lkm
	chmod +x $(PREFIX)/bin/light-sudo

	@printf "\033[1;38;2;254;228;208m[+] LKM-kernel installed, run with 'lkm'\033[0m\n"

uninstall:
	rm -f $(PREFIX)/bin/lkm $(PREFIX)/bin/light-sudo
	rm -rf $(PREFIX)/share/LKM-kernel
	@printf "\033[1;38;2;254;228;208m[+] LKM-kernel uninstalled\033[0m\n"

install-dependence:
	@echo "\033[1;38;2;254;228;208m[+] Installing dependencies...\033[0m"
	@apt install root-repo -y
	@apt install fzf fzy git jq sqlite -y

pack-deb:
	@mkdir -pv $(O)/deb/data/data/com.termux/files/usr/bin
	@mkdir -pv $(O)/deb/data/data/com.termux/files/usr/share/LKM-kernel
	@cp -rv share/* $(O)/deb/data/data/com.termux/files/usr/share/LKM-kernel/
	@cp -rv src/* $(O)/deb/data/data/com.termux/files/usr/bin/
	@cp -rv dpkg-conf $(O)/deb/DEBIAN
	@printf "\033[1;38;2;254;228;208m[+] Building packages.\033[0m\n" && sleep 1s
	@chmod -Rv 755 $(O)/deb/DEBIAN
	@chmod -Rv 755 $(O)/deb/data/data/com.termux/files/usr/bin
	@chmod -Rv 755 $(O)/deb/data/data/com.termux/files/usr/share/LKM-kernel
	@chmod -Rv 755 $(O)/deb/data/data/com.termux/files/usr/bin/lkm
	@chmod -Rv 755 $(O)/deb/data/data/com.termux/files/usr/bin/light-sudo
	@cd $(O)/deb && dpkg -b . ../../LKM-kernel.deb
	@printf "\033[1;38;2;254;228;208m[*] Build done, package: LKM-kernel.deb\033[0m\n"
	@rm -rf ./out
