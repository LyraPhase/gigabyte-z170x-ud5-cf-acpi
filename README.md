# ACPI Table Extraction and Disassembly

This project provides a Makefile-based workflow for extracting and disassembling
ACPI tables from a system. It's particularly useful for analyzing and modifying
ACPI tables for QEMU VMs, hackintosh, or system debugging purposes.

## Prerequisites

- `acpidump` - For dumping ACPI tables from the system
- `acpixtract` - For extracting individual ACPI tables from the dump
- `iasl` - Intel ACPI Source Language compiler for disassembling tables

## Usage

The workflow consists of several GNU `make` targets:

1. **Dump ACPI Tables**
   ```bash
   make acpidump
   ```
   This creates a hex dump of all ACPI tables from your system.

2. **Extract Individual Tables**
   ```bash
   make extract
   ```
   This extracts the DSDT and SSDT tables into separate files.

3. **Disassemble Tables**
   ```bash
   make disassemble
   ```
   This converts the binary ACPI tables into human-readable ASL (ACPI Source
   Language) format.
4. **Help**
   ```bash
   make help
   ```
   Prints an auto-generated help text for all targets that have a help text
   comment (Denoted by ` ## <help text here>`).

Each `Makefile` target can be run individually, and they will run all
prerequisites in order.

For example:

- `make extract` depends on `acpidump` so it will be run before `acpixtract`
  runs.
- Likewise, `make disassemble` depends on the files created from both `extract`
  and `acpidump`.  So, those prerequisites will be made before using Intel's
  ASL+ disassembler to generate the `ACPI/*.dsl` files

## Generated Files

- `gigabyte-z170x-ud5-cf-acpidump.hex` - Raw ACPI table dump for the Gigabyte
  Z170X-UD5 motherboard.
- `acpixtract/` - Directory containing extracted binary tables
- `ACPI/` - Directory containing disassembled `.dsl` files

> [!NOTE]
> If dumping your own motherboard's ACPI tables, be sure to set the `acpidump`
> `Makefile` variable to an appropriate filename for your motherboard.

## Cleaning Up

To remove all generated files except the `.hex` `acpidump` file:

```bash
make clean
```
