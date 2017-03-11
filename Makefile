## Configuration #####################################################

DOMAIN         ?= emacsmirror.net
PUBLIC         ?= https://$(DOMAIN)
PUBLISH_BUCKET ?= s3://$(DOMAIN)
PREVIEW_BUCKET ?= s3://preview.$(DOMAIN)
S3_DOMAIN      ?= s3-website.eu-central-1.amazonaws.com
PUBLISH_S3_URL ?= http://$(DOMAIN).$(S3_DOMAIN)
PREVIEW_S3_URL ?= http://preview.$(DOMAIN).$(S3_DOMAIN)

SRC   = _site
DST   =
PORT ?= 4200
SYNC  = --exclude "manual/*"
SYNC += --include "manual/index.html"
SYNC += --exclude "stats/*"
SYNC += --include "stats/index.html"
#NOT  https://github.com/emacscollective/borg => /manual/borg{/*,.html,.pdf}
#NOT  https://github.com/emacscollective/epkg => /manual/epkg{/*,.html,.pdf}

## Usage #############################################################

help:
	$(info )
	$(info make build          - build using jekyll)
	$(info make serve          - run a local jekyll server)
	$(info make preview        - upload to preview site)
	$(info make publish        - upload to production site)
	$(info make publish-other  - upload from related repos)
	$(info make clean          - remove build directory)
	$(info make ci-install     - install required tools)
	$(info make ci-version     - print version information)
	$(info )
	$(info Public:  $(PUBLIC))
	$(info Preview: $(PREVIEW_S3_URL))
	$(info Publish: $(PUBLISH_S3_URL))
	@echo
	@grep -e "^SRC" -e "^DST" -e "^SYNC" -e "^#NOT" Makefile
	@echo

## Targets ###########################################################

build:
	@jekyll build

serve:
	@jekyll serve -P $(PORT)

preview:
	@echo "Uploading to $(PREVIEW_BUCKET)..."
	@aws s3 sync $(SRC) $(PREVIEW_BUCKET)$(DST) --delete $(SYNC)

publish: clean build
	@if test $$(git symbolic-ref --short HEAD) = master; \
	then echo "Uploading to $(PUBLISH_BUCKET)..."; \
	else echo "ERROR: Only master can be published"; exit 1; fi
	@aws s3 sync $(SRC) $(PUBLISH_BUCKET)$(DST) --delete $(SYNC)

publish-other:
	@echo "Publishing from related repositories..."
	make -C ~/.emacs.d/lib/borg publish
	make -C ~/.emacs.d/lib/epkg publish

clean:
	@echo "Cleaning..."
	@rm -rf _site

ci-install:
	@apt-get -qq update
	@apt-get -qq install python-dev python-pip
	@gem install jekyll
	@pip install awscli

ci-version:
	@aws --version
	@jekyll --version
