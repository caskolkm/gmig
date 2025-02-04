VERSION := $(shell git describe --always)

clean:
	rm -rf target

build:
	docker run --rm -it -v "${PWD}":/src -w /src golang make build_inside

build_inside:
	cd /src && \
	rm -rf target && \
	mkdir -p target/windows && \
	mkdir -p target/darwin && \
	mkdir -p target/linux && \
	GOOS=windows go build -ldflags "-X main.version=$(VERSION)" -o target/windows/gmig.exe && \
	GOOS=darwin go build -ldflags "-X main.version=$(VERSION)" -o target/darwin/gmig && \
	GOOS=linux go build -ldflags "-X main.version=$(VERSION)" -o target/linux/gmig && \
	chmod +x -R target

zip:
	zip target/darwin/gmig.zip target/darwin/gmig && \
	zip target/linux/gmig.zip target/linux/gmig && \
	zip target/windows/gmig.zip target/windows/gmig.exe

# go get github.com/aktau/github-release
# export GITHUB_TOKEN=...
.PHONY: createrelease
createrelease:
	github-release info -u emicklei -r gmig
	github-release release \
		--user emicklei \
		--repo gmig \
		--tag $(shell git describe --abbrev=0 --tags) \
		--name "gmig" \
		--description "gmig - google infrastructure-as-code tool"

.PHONY: uploadrelease
uploadrelease:
	github-release upload \
		--user emicklei \
		--repo gmig \
		--tag $(shell git describe --abbrev=0 --tags) \
		--name "gmig-Linux-x86_64.zip" \
		--file target/linux/gmig.zip

	github-release upload \
		--user emicklei \
		--repo gmig \
		--tag $(shell git describe --abbrev=0 --tags) \
		--name "gmig-Darwin-x86_64.zip" \
		--file target/darwin/gmig.zip

	github-release upload \
		--user emicklei \
		--repo gmig \
		--tag $(shell git describe --abbrev=0 --tags) \
		--name "gmig-Windows-x86_64.zip" \
		--file target/windows/gmig.zip

release: build zip createrelease uploadrelease