
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

acpixtract/$(ssdt) acpixtract/$(dsdt)&: acpixtract $(acpidump) ## no-help
	cd acpixtract && acpixtract ../$(acpidump)

.PHONY: extract
extract: acpixtract/$(ssdt) acpixtract/$(dsdt) ## Extract ACPI tables

ACPI: ## no-help
	mkdir ACPI

ACPI/$(dsdt:dat=dsl): ACPI extract
	iasl -e $(addprefix acpixtract/, $(ssdt)) -p ACPI/$(basename $(dsdt)) -d acpixtract/$(dsdt)

# Disassemble all ssdt including external symbols found in other SSDTs
# ACPI/$(ssdt:dat=dsl): ACPI extract
ACPI/ssdt%.dsl: ACPI extract
	iasl -e $(addprefix acpixtract/, $(ssdt)) -p $(basename $@) -d acpixtract/$(basename $(notdir $@)).dat

.PHONY: dsdt ssdt
dsdt: ACPI/$(dsdt:dat=dsl) ## no-help
ssdt: $(addprefix ACPI/, $(ssdt:dat=dsl)) ## no-help

.PHONY: disassemble
disassemble: ssdt dsdt ## Disassemble DSDT and all SSDTs

.PHONY: clean
clean:: ## Clean up generated files
	rm -rf ./acpixtract
	rm -rf ./ACPI
