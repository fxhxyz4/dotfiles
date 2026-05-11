.PHONY: all install packages hyde configs services help

all: install

install:
	@bash install.sh

packages:
	@bash packages/install-packages.sh

hyde:
	@git clone https://github.com/HyDE-Project/HyDE.git ~/HyDE
	@(cd ~/HyDE && bash install.sh)

configs:
	@cp -r configs/. ~/.config/
	@cp shell/.zshenv ~/
	@cp misc/.gitconfig ~/
	@echo "✓ configs restored"

services:
	@sudo systemctl enable --now NetworkManager bluetooth sddm tlp ufw docker libvirtd
	@echo "✓ services enabled"

help:
	@echo "Usage:"
	@echo "  make          — full installation"
	@echo "  make packages — install packages only"
	@echo "  make hyde     — install HyDE only"
	@echo "  make configs  — restore configs only"
	@echo "  make services — enable services only"