PROJ_DIR := ${CURDIR}
OUT_DIR := $(PROJ_DIR)/Sources/SFSafeSymbols/Symbols/
SWIFT_CMD := swift run -c release --package-path SymbolsGenerator SymbolsGenerator $(OUT_DIR)

# Extract arguments
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: default release pr

DEFAULT := $(SWIFT_CMD) --dev

# make
default:
	$(DEFAULT)

dev:
	$(DEFAULT) $(ARGS)

# make release [tag]
release:
	$(SWIFT_CMD) --release $(if $(word 1, $(ARGS)),--tag $(word 1, $(ARGS)))

# make pr                              (detects the username and branch from git)
# make pr <username> <branch-name>
pr:
	$(SWIFT_CMD) --pr $(ARGS)

%:
	@:
