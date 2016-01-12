.PHONY: install server watch env
ELM_ENTRY = src/Main.elm
DEVD_VERSION = 0.3
WELLINGTON_VERSION = 1.0.0
OS := $(shell uname)

ifeq ($(OS),Darwin)
	DEVD_URL = "https://github.com/cortesi/devd/releases/download/v${DEVD_VERSION}/devd-${DEVD_VERSION}-osx64.tgz"
else
	DEVD_URL = "https://github.com/cortesi/devd/releases/download/v${DEVD_VERSION}/devd-${DEVD_VERSION}-linux64.tgz"
endif

ifeq ($(OS),Darwin)
	WELLINGTON_URL = "https://github.com/wellington/wellington/releases/download/v${WELLINGTON_VERSION}/wt_v${WELLINGTON_VERSION}_darwin_amd64.zip"
else
	WELLINGTON_URL = "https://github.com/wellington/wellington/releases/download/v${WELLINGTON_VERSION}/wt_v${WELLINGTON_VERSION}_linux_amd64.tar.gz"
endif

all: interop/translation-names.js build build/main.js build/main.css build/index.html build/interop.js build/*.svg

build:
	mkdir -p build

bin:
	mkdir -p bin

interop:
	mkdir -p interop

interop/translation-names.js: src/*.elm src/**/*.elm
	scripts/extract_translations.sh

bin/devd:
	curl ${DEVD_URL} -L -o $@.tgz
	tar -xzf $@.tgz -C bin/ --strip 1
	rm $@.tgz

bin/wellington:
	curl ${WELLINGTON_URL} -L -o $@.tgz
	tar -xzf $@.tgz -C bin/ --strip 1
	rm $@.tgz

build/main.css: styles/main.scss
	bin/wt compile -b build/ $?

build/main.js: src/*.elm src/**/*.elm
	elm make $(ELM_ENTRY) --yes --warn --output $@

build/index.html: index.html
	cp $? $@
	sed -i.bak -e "s,{{UI_PATH}},$$UI_PATH,g" $@ && rm build/*.html.bak

env:
	scripts/env.sh > interop/env.js

build/interop.js: interop/*.js
	cat $^ > $@

build/%: images/%
	cp $? build/$(<F)

install: bin interop env bin/devd bin/wellington

server:
	bin/devd -w build -l build/

watch:
	watchman-make -p 'src/**/*.elm' -t interop/translation-names.js build/main.js \
								-p 'styles/*.scss styles/bootstrap/scss/*.scss' -t build/main.css \
								-p 'index.html' -t build/index.html \
								-p 'interop/*.js' -t build/interop.js \
								-p 'images/*' -t build/images
