#include "hardware.h"

#define JIFFY 5000 /* Delay in micro seconds.*/

static const int a = 7;
static int b = 8;
static int sum;

// Begin test vars

unsigned int mymask = 1 << 3;

static const unsigned testVals[] = {
	0xF000, 0xEFFF
};

static const unsigned testVals1[] = {
	0x27C0, 0x5B10, 0x9F20
};

// End test vars


void delay(unsigned n)
{
	unsigned t = n << 1;
	while (t > 0) {
		nop(); nop(); nop();	/* nop = No Operation, assembler macro. */
		t--;
	}
}

void show(const unsigned *num, int n)
{
	while (n-- > 0) {

		for (int p = 0; p < 3; p++) {
			GPIO_OUT = num[0];
			delay(JIFFY);
		}
	}
}

void myShow(int n) {

	while (n-- > 0)
	{
		GPIO_OUT = 0xE000;	/* Corresponds to bit value: 1110 0000 0000 0000 - which turns on all LEDs. */
		delay(JIFFY);
	}
}

void myShow1(int n, const unsigned * vals) {

	while (n-- > 0)
	{
		for (int i = 0; i < 3; i++) {

			GPIO_OUT = vals[i];
			delay(JIFFY);
		}
	}
}

void init(void)
{
	GPIO_DIR = 0xfff0;
	GPIO_PINCNF[BUTTON_A] = 0;
	GPIO_PINCNF[BUTTON_B] = 0;

	sum = a + b;

	while (1) {
		myShow1(500, testVals1);
	}
}