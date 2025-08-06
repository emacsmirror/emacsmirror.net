## Configuration #####################################################

DOMAIN         ?= emacsmirror.net
PUBLIC         ?= https://$(DOMAIN)
CFRONT_DIST    ?= E1IXJGPIOM4EUW
PUBLISH_BUCKET ?= s3://$(DOMAIN)
S3_DOMAIN      ?= s3-website.eu-central-1.amazonaws.com
PUBLISH_S3_URL ?= http://$(DOMAIN).$(S3_DOMAIN)

SRC   = _site
DST   =
PORT ?= 4200
SYNC  = --exclude "manual/*"
SYNC += --include "manual/dir/index.html"
SYNC += --include "manual/dir.html"
SYNC += --include "manual/index.html"
SYNC += --exclude "stats/*"
SYNC += --include "stats/index.html"
#NOT  https://github.com/emacscollective/borg => /manual/borg{/*,.html,.pdf}
#NOT  https://github.com/emacscollective/epkg => /manual/epkg{/*,.html,.pdf}

FONTS = Noto+Sans:400,400i,700,700i|Noto+Serif:400,400i,700,700i

## Usage #############################################################

help:
	$(info )
	$(info make build          - build using jekyll)
	$(info make serve          - run a local jekyll server)
	$(info make publish        - upload to production site)
	$(info make publish-other  - upload from related repos)
	$(info make update-fonts   - download updated fonts)
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

publish:
	@if test $$(git symbolic-ref --short HEAD) = main; \
	then echo "Uploading to $(PUBLISH_BUCKET)..."; \
	else echo "ERROR: Only main can be published"; exit 1; fi
	@aws s3 sync $(SRC) $(PUBLISH_BUCKET)$(DST) --delete $(SYNC)
	@aws cloudfront create-invalidation \
	--distribution-id $(CFRONT_DIST) --paths "/*" > /dev/null

publish-other:
	@echo "Publishing from related repositories..."
	make -C ~/.emacs.d/lib/borg publish
	make -C ~/.emacs.d/lib/epkg publish

update-fonts:
	@mkdir -p assets/fonts
	@cd assets/fonts; google-font-download -o ../font.css -f woff2,woff -u \
	"https://fonts.googleapis.com/css?family=$(FONTS)"
	@cd assets; sed -i -e "s:url('Noto:url('/assets/fonts/Noto:" font.css

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
