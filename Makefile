PROJ_DIR := ${CURDIR}
OUT_DIR := $(PROJ_DIR)/Sources/SFSafeSymbols/Symbols/
SWIFT_CMD := swift run -c release --package-path SymbolsGenerator SymbolsGenerator $(OUT_DIR)

# Extract arguments
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: default release fork

DEFAULT := $(SWIFT_CMD) --dev

# make
default:
	$(DEFAULT)

dev:
	$(DEFAULT)

# make release [tag]
release:
	$(SWIFT_CMD) --release $(if $(word 1, $(ARGS)),--tag $(word 1, $(ARGS)))

# make fork [user] [branch]
fork:
	$(SWIFT_CMD) --fork $(if $(word 1, $(ARGS)),--username $(word 1, $(ARGS))) $(if $(word 2, $(ARGS)),--branch $(word 2, $(ARGS)))

%:
	@:
