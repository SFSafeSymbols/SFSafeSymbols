PROJ_DIR := ${CURDIR}

default: generate-symbol

generate-symbol:
	cd SymbolsGenerator && \
	swift run SymbolsGenerator $(PROJ_DIR)/Sources/SFSafeSymbols/Symbols/

.PHONY: generate-symbol
