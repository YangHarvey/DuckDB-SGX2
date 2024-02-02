ARCH_LIBDIR ?= /lib/$(shell $(CC) -dumpmachine)

ifeq ($(DEBUG),1)
GRAMINE_LOG_LEVEL = debug
else
GRAMINE_LOG_LEVEL = error
endif

.PHONY: all
all: duckdb.manifest
ifeq ($(SGX),1)
all: duckdb.manifest.sgx duckdb.sig
endif

duckdb.manifest: duckdb.manifest.template
	gramine-manifest \
		-Dlog_level=$(GRAMINE_LOG_LEVEL) \
		-Dexecdir="duckdb" \
		-Darch_libdir=$(ARCH_LIBDIR) \
		$< >$@

duckdb.manifest.sgx duckdb.sig: sgx_sign
	@:

.INTERMEDIATE: sgx_sign
sgx_sign: duckdb.manifest
	gramine-sgx-sign \
		--manifest $< \
		--output $<.sgx

ifeq ($(SGX),)
GRAMINE = gramine-direct
else
GRAMINE = gramine-sgx
endif

# Note that command-line arguments are hardcoded in the manifest file.
.PHONY: regression
regression: all
	@$(RM) db/*

	$(GRAMINE) duckdb < scripts/test.sql
	@echo "[ Success 1/1 ]"

.PHONY: clean
clean:
	$(RM) *.manifest *.manifest.sgx *.token *.sig OUTPUT db/*

.PHONY: distclean
distclean: clean
