
ifneq ("$(wildcard ./main.mk)","")
include ./main.mk
endif

## Filenames
acpidump = gigabyte-z170x-ud5-cf-acpidump.hex
dsdt = dsdt.dat
ssdt = ssdt1.dat ssdt2.dat ssdt3.dat ssdt4.dat ssdt5.dat ssdt6.dat ssdt7.dat ssdt8.dat ssdt9.dat

$(acpidump): ## no-help
	sudo acpidump > $@

.PHONY: acpidump
acpidump: $(acpidump) ## Dump ACPI tables from system

acpixtract: ## no-help
	mkdir acpixtract

$(addprefix acpixtract/, $(ssdt)) $(addprefix acpixtract/, $(dsdt))&: $(acpidump) | acpixtract ## no-help
	@echo 'Target caused this to run: $@'
	@echo 'Prerequisites newer than target: $?'
	cd acpixtract && acpixtract ../$(acpidump)

.PHONY: extract
extract: $(addprefix acpixtract/, $(ssdt)) $(addprefix acpixtract/, $(dsdt)) ## Extract ACPI tables

ACPI: ## no-help
	mkdir ACPI

$(addprefix ACPI/, $(dsdt:dat=dsl)): $(addprefix acpixtract/, $(ssdt)) $(addprefix acpixtract/, $(dsdt)) | ACPI ## no-help
	iasl -e $(addprefix acpixtract/, $(ssdt)) -p ACPI/$(basename $(dsdt)) -d acpixtract/$(dsdt)

# Disassemble all ssdt including external symbols found in other SSDTs
ACPI/ssdt%.dsl: $(addprefix acpixtract/, $(ssdt)) | ACPI ## no-help
	iasl -e $(addprefix acpixtract/, $(ssdt)) -p $(basename $@) -d acpixtract/$(basename $(notdir $@)).dat

.PHONY: dsdt ssdt
dsdt: ACPI/$(dsdt:dat=dsl) ## no-help
ssdt: $(addprefix ACPI/, $(ssdt:dat=dsl)) ## no-help

.PHONY: disassemble
disassemble: ssdt dsdt ## Disassemble DSDT and all SSDTs

compiled: ## no-help
	mkdir compiled

# Compile DSDT including external symbols found in other SSDTs
compiled/%.aml: $(addsuffix .dsl, $(addprefix ACPI/, $(basename $@))) | compiled ## no-help
	iasl -e $(addprefix ACPI/, $(ssdt:dat=dsl)) -p $(basename $@) $(addprefix ACPI/, $(notdir $(basename $@)).dsl)

.PHONY: compile-dsdt compile-ssdt
compile-dsdt: ACPI/$(dsdt:dat=dsl) ## no-help
compile-ssdt: $(addprefix ACPI/, $(ssdt:dat=dsl)) $(addprefix compiled/, $(ssdt:dat=aml)) ## no-help

.PHONY: compile
compile: compile-dsdt compile-ssdt ## Compile DSDT including external symbols from all SSDTs


.PHONY: clean
clean:: ## Clean up generated files
	rm -rf ./acpixtract
	rm -rf ./ACPI
	rm -rf ./compiled
