set shell := ["zsh", "-cu"]

bootstrap:
	@echo "🍺 Installing Homebrew bundles..."

	# Brewfiles are inside install/brew/
	brew bundle --verbose --file=install/brew/Brewfile

	@echo "🍎 Applying macOS defaults..."
	bash setup/macos/defaults.sh

	@echo "💻 Installing SDKMAN"
	just sdkman

	@echo "🔗 Stowing dotfiles..."
	cd config && stow --adopt --target="$HOME" git zsh starship bat ghostty karabiner

	@echo "✅ Bootstrap complete"

check:
	bash scripts/check.sh

sdkman:
	@echo "💻 Installing SDKMAN..."
	curl -s "https://get.sdkman.io" | bash || true
	grep -qxF 'export SDKMAN_DIR="$HOME/.sdkman"' ~/.zshrc || echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> ~/.zshrc
	grep -qxF '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' ~/.zshrc || echo '[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"' >> ~/.zshrc
	# Load SDKMAN for current session
	