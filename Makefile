GRIP=python -m grip
MKDIR_P=mkdir -p

MOCHA_REPO=https://github.com/mochajs/mochajs.github.io
MOCHA_SOURCE=modules/mochajs.github.io
MOCHA_DEST=_output/mochajs

MOMENT_REPO=https://github.com/mochajs/mochajs.github.io
MOMENT_SOURCE=momentjs.com
MOMENT_DEST=_output/momentjs

NORMALIZR_SOURCE=normalizr
NORMALIZR_DEST=_output/normalizr

REACT_SOURCE=react/docs
REACT_DEST=_output/react

REDUX_SOURCE=redux
REDUX_DEST=_output/redux

REDUXAPI_SOURCE=redux-api-middleware
REDUXAPI_DEST=_output/redux-api-middleware

RESELECT_SOURCE=reselect
RESELECT_DEST=_output/reselect

WEBPACK_SOURCE=webpack.js.org
WEBPACK_DEST=_output/webpack

MDN_SOURCE=mdn
MDN_DEST=_output/mdn

build: _output/index.html \
			 _output/expect/index.html \
			 _output/enzyme/index.html \
			 _output/immutable-js/index.html \
			 $(MOCHA_DEST)/index.html \
			 $(MOMENT_DEST)/index.html \
			 $(NORMALIZR_DEST)/index.html \
			 $(REACT_DEST)/index.html \
			 $(REDUX_DEST)/index.html \
			 $(REDUXAPI_DEST)/index.html \
			 $(RESELECT_DEST)/index.html \
			 $(WEBPACK_DEST)/index.html \
			 $(MDN_DEST)

package: docs.tar.gz

docs.tar.gz: build
	tar cafh docs.tar.gz _output/

clean:
	rm -rf _output/*

_output/index.html: README.md
	$(MKDIR_P) _output
	$(GRIP) README.md --export _output/index.html

_output/expect/index.html: expect/README.md
	$(MKDIR_P) _output/expect
	$(GRIP) expect/README.md --export _output/expect/index.html

_output/enzyme/index.html: enzyme/_book
	$(MKDIR_P) _output/enzyme
	cp -R enzyme/_book/* _output/enzyme

enzyme/_book: enzyme/docs
	npm --prefix ./enzyme install
	npm --prefix ./enzyme run docs:build

_output/immutable-js/index.html: immutable-js/pages/out
	$(MKDIR_P) _output/immutable-js
	cp -R immutable-js/pages/out/* _output/immutable-js

immutable-js/pages/out: immutable-js/pages
	npm --prefix ./immutable-js install
	npm --prefix ./immutable-js run build

$(MOCHA_DEST)/index.html: $(MOCHA_SOURCE)/_site
	$(MKDIR_P) $(MOCHA_DEST)
	cp -R $(MOCHA_SOURCE)/_site/* $(MOCHA_DEST)

$(MOCHA_SOURCE)/_site: $(MOCHA_SOURCE)/
	bundle install --gemfile ./$(MOCHA_SOURCE)/Gemfile
	npm --prefix ./$(MOCHA_SOURCE) install
	npm --prefix ./$(MOCHA_SOURCE) start build

$(MOCHA_SOURCE)/:
	git clone $(MOCHA_REPO) $(MOCHA_SOURCE)

$(MOMENT_DEST)/index.html: $(MOMENT_SOURCE)/build
	$(MKDIR_P) $(MOMENT_DEST)
	cp -R $(MOMENT_SOURCE)/build/* $(MOMENT_DEST)
	find ./$(MOMENT_DEST) -type f -name '*.html' -print0 | xargs -0 perl -pi -e 's/(href|src)="\/([a-zA-Z0-9])/$$1="\/momentjs\/$$2/g'

$(MOMENT_SOURCE)/build: $(MOMENT_SOURCE)/
	$(MOMENT_SOURCE)/compile.sh

$(NORMALIZR_DEST)/index.html: $(NORMALIZR_SOURCE)/README.md
	$(MKDIR_P) $(NORMALIZR_DEST)
	$(GRIP) $(NORMALIZR_SOURCE)/README.md --export $(NORMALIZR_DEST)/index.html

$(REACT_DEST)/index.html: $(REACT_SOURCE)/_site
	$(MKDIR_P) $(REACT_DEST)
	cp -R $(REACT_SOURCE)/_site/* $(REACT_DEST)

$(REACT_SOURCE)/_site: $(REACT_SOURCE)/
	$(shell cd $(REACT_SOURCE); bundle install; npm install; bundle exec rake; bundle exec rake fetch_remotes; bundle exec jekyll build;)

$(REDUX_DEST)/index.html: $(REDUX_SOURCE)/_book
	$(MKDIR_P) $(REDUX_DEST)
	cp -R $(REDUX_SOURCE)/_book/* $(REDUX_DEST)

$(REDUX_SOURCE)/_book: $(REDUX_SOURCE)/
	npm --prefix ./$(REDUX_SOURCE) install
	npm --prefix ./$(REDUX_SOURCE) run docs:build

$(REDUXAPI_DEST)/index.html: $(REDUXAPI_SOURCE)/README.md
	$(MKDIR_P) $(REDUXAPI_DEST)
	$(GRIP) $(REDUXAPI_SOURCE)/README.md --export $(REDUXAPI_DEST)/index.html

$(RESELECT_DEST)/index.html: $(RESELECT_SOURCE)/README.md
	$(MKDIR_P) $(RESELECT_DEST)
	$(GRIP) $(RESELECT_SOURCE)/README.md --export $(RESELECT_DEST)/index.html

$(WEBPACK_DEST)/index.html: $(WEBPACK_SOURCE)/build
	$(MKDIR_P) $(WEBPACK_DEST)
	cp -R $(WEBPACK_SOURCE)/build/* $(WEBPACK_DEST)
	find ./$(WEBPACK_DEST) -type f -name '*.html' -print0 | xargs -0 perl -pi -e 's/(href|src)="\/([a-zA-Z0-9])/$$1="\/webpack\/$$2/g'

$(WEBPACK_SOURCE)/build: $(WEBPACK_SOURCE)/
	npm --prefix ./$(WEBPACK_SOURCE) install
	npm --prefix ./$(WEBPACK_SOURCE) run build

$(MDN_DEST): $(MDN_SOURCE)
	ln -s $(CURDIR)/$(MDN_SOURCE) _output/.
