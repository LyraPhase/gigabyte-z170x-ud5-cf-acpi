
acpidump = gigabyte-z170x-ud5-cf-acpidump.hex
dsdt = dsdt.dat
ssdt = ssdt1.dat ssdt2.dat ssdt3.dat ssdt4.dat ssdt5.dat ssdt6.dat ssdt7.dat ssdt8.dat ssdt9.dat

acpixtract:
	mkdir acpixtract

acpixtract/$(ssdt) acpixtract/$(dsdt) &: acpixtract $(acpidump)
	cd acpixtract && acpixtract ../$(acpidump)

extract: acpixtract/$(ssdt) acpixtract/$(dsdt)

ACPI:
	mkdir ACPI

ACPI/$(dsdt:dat=dsl): ACPI extract
	iasl -e $(addprefix acpixtract/, $(ssdt)) -p ACPI/$(basename $(dsdt)) -d acpixtract/$(dsdt)
# iasl  -d acpixtract/$(dsdt)

disassemble: ACPI/$(dsdt:dat=dsl)

clean::
	rm -rf ./acpixtract
	rm -rf ./ACPI
