ARCH_LIBDIR ?= /lib/$(shell $(CC) -dumpmachine)

ifeq ($(DEBUG),1)
GRAMINE_LOG_LEVEL = debug
else
GRAMINE_LOG_LEVEL = error
endif

.PHONY: all
all: benchmark_runner.manifest
ifeq ($(SGX),1)
all: benchmark_runner.manifest.sgx benchmark_runner.sig
endif

benchmark_runner.manifest: benchmark_runner.manifest.template
	gramine-manifest \
		-Dlog_level=$(GRAMINE_LOG_LEVEL) \
		-Dexecdir=$(dir $(shell pwd)) \
		-Darch_libdir=$(ARCH_LIBDIR) \
		$< >$@

benchmark_runner.manifest.sgx benchmark_runner.sig: sgx_sign
	@:

.INTERMEDIATE: sgx_sign
sgx_sign: benchmark_runner.manifest
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

	$(GRAMINE) benchmark_runner benchmark/micro/nulls/no_nulls_addition.benchmark --out=timings.out
	@echo "[ Success 1/1 ]"

.PHONY: clean
clean:
	$(RM) *.manifest *.manifest.sgx *.token *.sig OUTPUT db/*

.PHONY: distclean
distclean: clean
