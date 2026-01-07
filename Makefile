all: setup pull

pull:
	cd ~/.config/nvim-labs && git pull

update:
	cp -r ~/.config/nvim-labs/* ./

setup:
	sh setup.sh 
