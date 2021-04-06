include repos.mk
include versions.mk

all = $(shell awk '{ print $$1 }' versions.mk)

.PHONY: info all test

info: versions.mk
	@printf "Available projects\n\n"
	@cat versions.mk

all: $(all)

test: $(all:%=%_test)

define builder
.PHONY: $(1) $(1)_test

$(1): lib/json/$(1).json

$(1)_test: lib/json/$(1).json
	nix-build test.nix -A $(1) --no-out-link
endef
$(foreach target,$(all),$(eval $(call builder,$(target))))

lib/json/%.json: versions.mk
	@mkdir -p $(@D)
	nix-prefetch-github $($*_org) $($*_repo) --rev $($*) | tee $@
