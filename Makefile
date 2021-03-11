PROJ_DIR := ${CURDIR}

default: generate-symbol

generate-symbol:
	cd SymbolEnumCreator && \
	swift run SymbolEnumCreator > $(PROJ_DIR)/Sources/SFSafeSymbols/Enum/SFSymbol.swift

.PHONY: generate-symbol
