/*
*	TERMS:
*	VMA = Virtual Memory Address; The address on which data is stored but not run.
*	LMA = Load Memory Address; The address onto which data is stored for the purpose of running the code. !Read up and get better definition.
*/

/* Experiment with adding MEMORY regions to flush the sections to. */

/*
*MEMORY
*{
*		FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x40000
*		RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x4000
*}
*/

/* End MEMORY regions, begin SECTIONS command. */
SECTIONS
{
	. = 0x0;					/* Set location pointer to 0x00000000 */

	.text :						/* Code (.text) section. */
	{
		*(vectors)				/* Place vector table at this point in the section. */
		*(.text)				/* Place program code at this point in the section. */
	}

	.rodata :
	{
		*(.rodata)
	}

	_DATA_ROM_START = .;		 /* Set ROM_START to current location. */

	. = 0x20000000;				/* Set position of the location pointer to 0x20000000 */

	_DATA_RAM_START = .;		/* Set RAM_START to current location. */

	.data :	AT(_DATA_ROM_START)	/* Initialized read-write AND read-only data section. Assign its VMA */
	{
		*(.data)				/* Place initialized code at this point in the data section (based on location counter). */
	}

	_DATA_RAM_END = .;

	_BSS_START = .;

	.bss :						/* Uninitialized data section. As is, it is placed at the end of 0x20000000 + length of the .data section (Currently in RAM). */
	{
		*(.bss)
	}

	_BSS_END = .;
}