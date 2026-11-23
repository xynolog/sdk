.DEFAULT_GOAL := build

LANGUAGES := typescript python rust go csharp haskell kotlin ocaml swift

.PHONY: help build codegen test test-tooling generate check-generated test-codegen verify-artifacts tag-release publish clean clean-local $(LANGUAGES) $(addprefix test-,$(LANGUAGES)) $(addsuffix -clean,$(LANGUAGES))

# `make help` prints the `##` lines below, in order (build-tools/make-help.awk).
##@ Xynolog SDK: make [target] [VARIABLE=value ...]
##@ Variables
## CONTAINER_RUNTIME=name: container|docker|podman; else the first to respond
CONTAINER_RUNTIME ?=
export CONTAINER_RUNTIME
## SDK_ARTIFACTS=path: Where a build writes its artifact bundle; the bundle verify-artifacts checks
export SDK_ARTIFACTS

help:
	@awk -v list="$(LANGUAGES)" -f build-tools/make-help.awk Makefile Makefile

##@ Build and stage
## build: Every SDK, as local artifacts and an artifact bundle
build:
	bash scripts/publish-local.sh

## <language>: One SDK: <list>
$(LANGUAGES):
	bash scripts/publish-local.sh $@

## codegen: The generator, as a local artifact and an artifact bundle, for another repository to write its generated files with
codegen:
	bash scripts/publish-local.sh codegen

## verify-artifacts: Check the artifact bundle SDK_ARTIFACTS names
verify-artifacts:
	@test -n "$(SDK_ARTIFACTS)" || { echo 'Set SDK_ARTIFACTS to an artifact bundle path.' >&2; exit 2; }
	python3 scripts/verify-artifact-bundle.py "$(SDK_ARTIFACTS)"

##@ Test
## test: Every SDK's own tests, type checks, lints and format checks
test: $(addprefix test-,$(LANGUAGES))

## test-<language>: One SDK's own tests and checks, in its toolchain's container, writing the tests' coverage under coverage/: <list>
$(addprefix test-,$(LANGUAGES)):
	bash scripts/make-target.sh $@

## test-tooling: The repository's own scripts and configs, outside the SDKs: each TypeScript and JavaScript one typechecked, every one in a tsconfig, and each Python one held to the Python SDK's type checks, lints and format checks
test-tooling:
	bash scripts/make-target.sh test-tooling

##@ Generate
## generate: Write every SDK's generated files from the pinned Protocol
generate:
	bash scripts/make-target.sh generate

## check-generated: Fail when a committed generated file differs from what its generator writes
check-generated:
	bash scripts/make-target.sh check-generated

## test-codegen: The generator's own tests and checks: its model reads every file of the pinned Protocol, each case table is run by a named test of each SDK or absent for a reason, each surface item an SDK lacks is one Protocol has, and every sdk path that Protocol names is here
test-codegen:
	bash scripts/make-target.sh test-codegen

##@ Release
## tag-release: On main, pull its latest commit and tag it as the release version.json names, once it is ready: sign and push vX.Y.Z, wait for its release workflow to release the bundle, then sign and push Go's go/vX.Y.Z
tag-release:
	bash scripts/tag-release.sh

## publish: Publish the release this commit is tagged as to each registry publish.yml offers, one run at a time, each approved in the release environment and watched to its end
publish:
	bash scripts/publish-release.sh

## publish-<registry>: Publish it to one of those registries, as publish-npm
publish-%:
	bash scripts/publish-release.sh $*

##@ Clean
## clean: Remove every language's output, the local artifacts, caches and bundles
clean:
	bash scripts/clean-sdk.sh all

## clean-local: Remove the local artifacts, caches and bundles
clean-local:
	bash scripts/clean-sdk.sh local

## <language>-clean: Remove one language's output and its package and compiler caches
$(addsuffix -clean,$(LANGUAGES)):
	bash scripts/clean-sdk.sh $(@:-clean=)
