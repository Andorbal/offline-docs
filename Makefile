GRIP=python -m grip
MKDIR_P=mkdir -p

MODULES=modules/
OUTPUT=output/

EXPECT_REPO=https://github.com/mjackson/expect
EXPECT_SOURCE=$(MODULES)expect/
EXPECT_DEST=$(OUTPUT)expect/

ENZYME_REPO=https://github.com/airbnb/enzyme
ENZYME_SOURCE=$(MODULES)enzyme/
ENZYME_DEST=$(OUTPUT)enzyme/

IMMUTABLE_REPO=https://github.com/facebook/immutable-js
IMMUTABLE_SOURCE=$(MODULES)immutable-js/
IMMUTABLE_DEST=$(OUTPUT)immutable-js/

MOCHA_REPO=https://github.com/mochajs/mochajs.github.io
MOCHA_SOURCE=$(MODULES)mochajs.github.io/
MOCHA_DEST=$(OUTPUT)mochajs/

MOMENT_REPO=https://github.com/moment/momentjs.com
MOMENT_SOURCE=$(MODULES)momentjs.com/
MOMENT_DEST=$(OUTPUT)momentjs/

NORMALIZR_REPO=https://github.com/paularmstrong/normalizr
NORMALIZR_SOURCE=$(MODULES)normalizr/
NORMALIZR_DEST=$(OUTPUT)normalizr/

REACT_REPO=https://github.com/facebook/react
REACT_SOURCE=$(MODULES)react/
REACT_DEST=$(OUTPUT)react/

REDUX_REPO=http://github.com/reactjs/redux
REDUX_SOURCE=$(MODULES)redux/
REDUX_DEST=$(OUTPUT)redux/

REDUXAPI_REPO=https://github.com/agraboso/redux-api-middleware
REDUXAPI_SOURCE=$(MODULES)redux-api-middleware/
REDUXAPI_DEST=$(OUTPUT)redux-api-middleware/

RESELECT_REPO=https://github.com/reactjs/reselect
RESELECT_SOURCE=$(MODULES)reselect/
RESELECT_DEST=$(OUTPUT)reselect/

WEBPACK_REPO=https://github.com/webpack/webpack.js.org
WEBPACK_SOURCE=$(MODULES)webpack.js.org/
WEBPACK_DEST=$(OUTPUT)webpack/

MDN_SOURCE=mdn
MDN_DEST=_output/mdn

build: _output/index.html \
			 $(EXPECT_DEST)index.html \
			 $(ENZYME_DEST)index.html \
			 $(IMMUTABLE_DEST)index.html \
			 $(MOCHA_DEST)index.html \
			 $(MOMENT_DEST)index.html \
			 $(NORMALIZR_DEST)index.html \
			 $(REACT_DEST)index.html \
			 $(REDUX_DEST)index.html \
			 $(REDUXAPI_DEST)index.html \
			 $(RESELECT_DEST)index.html \
			 $(WEBPACK_DEST)index.html \
			 $(MDN_DEST)

package: docs.tar.gz

docs.tar.gz: build
	tar cafh docs.tar.gz _output/

clean:
	rm -rf _output/*

_output/index.html: README.md
	$(MKDIR_P) _output
	$(GRIP) README.md --export _output/index.html

$(EXPECT_DEST)index.html: $(EXPECT_SOURCE)README.md
	$(MKDIR_P) $(EXPECT_DEST)
	$(GRIP) $^ --export $@

$(ENZYME_DEST)index.html: $(ENZYME_SOURCE)_book/
	$(MKDIR_P) $(ENZYME_DEST)
	cp -R $^* $(ENZYME_DEST)

$(ENZYME_SOURCE)_book: $(ENZYME_SOURCE)
	npm --prefix $(ENZYME_SOURCE) install
	npm --prefix $(ENZYME_SOURCE) run docs:build

$(IMMUTABLE_DEST)index.html: $(IMMUTABLE_SOURCE)pages/out
	$(MKDIR_P) $(IMMUTABLE_DEST)
	cp -R $^* $(IMMUTABLE_DEST)

$(IMMUTABLE_SOURCE)pages/out: $(IMMUTABLE_SOURCE)pages
	npm --prefix $(IMMUTABLE_SOURCE) install
	npm --prefix $(IMMUTABLE_SOURCE) run build

$(MOCHA_DEST)index.html: $(MOCHA_SOURCE)_site
	$(MKDIR_P) $(MOCHA_DEST)
	cp -R $^* $(MOCHA_DEST)

$(MOCHA_SOURCE)_site: $(MOCHA_SOURCE)
	bundle install --gemfile ./$(MOCHA_SOURCE)Gemfile
	npm --prefix $(MOCHA_SOURCE) install
	npm --prefix $(MOCHA_SOURCE) start build

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

$(REACT_DEST)/index.html: $(REACT_SOURCE)/docs/_site
	$(MKDIR_P) $(REACT_DEST)
	cp -R $(REACT_SOURCE)/docs/_site/* $(REACT_DEST)

$(REACT_SOURCE)/_site: $(REACT_SOURCE)/docs/
	$(shell cd $(REACT_SOURCE)/docs; bundle install; npm install; bundle exec rake; bundle exec rake fetch_remotes; bundle exec jekyll build;)

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

$(EXPECT_SOURCE): URL=$(EXPECT_REPO)
$(ENZYME_SOURCE): URL=$(ENZYME_REPO)
$(IMMUTABLE_SOURCE): URL=$(IMMUTABLE_REPO)
$(MOCHA_SOURCE)/: URL=$(MOCHA_REPO)
$(MOMENT_SOURCE): URL=$(MOMENT_REPO)
$(NORMALIZR_SOURCE): URL=$(NORMALIZR_REPO)
$(REACT_SOURCE): URL=$(REACT_REPO)
$(REDUX_SOURCE): URL=$(REDUX_REPO)
$(REDUXAPI_SOURCE): URL=$(REDUXAPI_REPO)
$(RESELECT_SOURCE): URL=$(RESELECT_REPO)
$(WEBPACK_SOURCE): URL=$(WEBPACK_REPO)

$(EXPECT_SOURCE) $(ENZYME_SOURCE) $(IMMUTABLE_SOURCE) $(MOCHA_SOURCE) $(MOMENT_SOURCE) $(NORMALIZR_SOURCE) \
$(REACT_SOURCE) $(REDUX_SOURCE) $(REDUXAPI_SOURCE) $(RESELECT_SOURCE) $(WEBPACK_SOURCE):
	git clone $(URL) $@
