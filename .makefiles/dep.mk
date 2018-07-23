SRC=./src
DEPS_VER=v0.2.1
DEPS_PREFIX=https://github.com/tyrchen/mix-deps/releases/download
BUILDS_FILE=builds.tgz
DEPS_FILE=deps.tgz
BUILDS_URL=$(DEPS_PREFIX)/$(DEPS_VER)/$(BUILDS_FILE)
DEPS_URL=$(DEPS_PREFIX)/$(DEPS_VER)/$(DEPS_FILE)

extract-deps:
	@cd $(SRC); wget $(BUILDS_URL); wget $(DEPS_URL); tar zxvf $(BUILDS_FILE); tar zxvf $(DEPS_FILE); rm $(BUILDS_FILE) $(DEPS_FILE);
