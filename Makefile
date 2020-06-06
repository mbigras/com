all: help

help:
	@echo "Com is a wrapper around other command-line utilities."
	@echo "This project is built using Docker."
	@echo "The build process is driven using make."
	@echo ""
	@echo "Common commands:"
	@echo ""
	@echo "make help"
	@echo "make deps"
	@echo "make build"
	@echo "make install"

build:
	docker build -t mbigras/com .

deps:
	@echo "This project uses Docker."
	@echo "For instructions on how to install docker on your system check out:"
	@echo ""
	@echo "https://docs.docker.com/get-docker/"

install: build
	cp com_wrapper /usr/local/bin/com
	com help