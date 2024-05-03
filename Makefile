build-nix-darwin: 
	nix build '.#darwinConfigurations.$(shell hostname).system'

darwin-rebuild:
	./result/sw/bin/darwin-rebuild switch --flake '.#$(shell hostname)'
