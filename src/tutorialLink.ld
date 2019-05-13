

MEMORY {
		FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x40000
		RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x4000
}

/* End MEMORY regions, begin SECTIONS command. */

OUTPUT_FORMAT("elf32-littlearm")

SECTIONS
{
	.text : {
		KEEP(*(.vectors))
		*(.text*)
		*(.rodata*)
		. = ALIGN(4);
	} > FLASH

	__etext = .;

	.data : AT (__etext) {
		__data_start = .;
		*(.data*)
		. = ALIGN(4);
		__data_end = .;
	} > RAM

	.bss : {
		__bss_start = .;
		*(.bss*)
		*(COMMMON)
		. = ALIGN(4);
		__bss_end = .;
		__end = .;
	} > RAM

	__stack = ORIGIN(RAM) + LENGTH(RAM);
	__stack_limit = __stack - 2048;

	ASSERT(__stack_limit >= __end, "Region RAM overlacks with stack.")
}