darwin-build: 
	nix build '.#darwinConfigurations.$(shell hostname).system'

darwin-rebuild-switch:
	./result/sw/bin/darwin-rebuild switch --flake '.#$(shell hostname)'

.PHONY: build-linux-builder-docker
build-linux-builder-docker:
	docker buildx build . -t nix-builder --file ./builder.dockerfile --platform=linux/amd64

build-nixos-docker: build-linux-builder-docker
	docker run --platform linux/amd64 -v builder-nix-store:/nix/store -v /Users/dave/config-nix-private:/Users/dave/config-nix-private -v $$(pwd):/nix-build -w /nix-build -it nix-builder nix build '.#nixosConfigurations.baracus-hyperv.config.system.build.toplevel'

home-build: 
	nix build '.#homeConfigurations.$(shell hostname).activationPackage'
