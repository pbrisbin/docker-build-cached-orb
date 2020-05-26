CIRCLECI ?= circleci --skip-update-check

ORB_REF     ?= pbrisbin/docker-build-cached
ORB_DEV_TAG ?= alpha

out/orb.yml: src/*.yml
	$(CIRCLECI) config pack src > out/orb.yml
	$(CIRCLECI) orb validate out/orb.yml

.PHONY: release.dev
release.dev: out/orb.yml
	$(CIRCLECI) orb publish out/orb.yml $(ORB_REF)@dev:$(ORB_DEV_TAG)

.PHONY: promote.patch
promote.patch:
	$(CIRCLECI) orb publish promote $(ORB_REF)@dev:$(ORB_DEV_TAG) patch

.PHONY: promote.minor
promote.minor:
	$(CIRCLECI) orb publish promote $(ORB_REF)@dev:$(ORB_DEV_TAG) minor

.PHONY: promote.major
promote.major:
	$(CIRCLECI) orb publish promote $(ORB_REF)@dev:$(ORB_DEV_TAG) major
