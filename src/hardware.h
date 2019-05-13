


#define BIT(i) (1 << (i))

#define SET_BIT(reg, n) reg |= BIT(n)
#define CLR_BIT(reg, n) reg &= ~BIT(n)

#define SET_FIELD(reg, field, val) \
	 reg = (reg & ~field##_Msk) | ((val) << field##_Pos)

#define SET_BYTE(reg, n, v) \
	 reg = (reg & ~(0xff << 8 * n)) | ((v & 0xff) << 8 * n)

#define ADDR(x)	(* (unsigned volatile *) (x))	// These likely waste memory - Proabably more efficient to provide specific macros for differently sized address spaces
#define ARRAY(x) ((unsigned volatile *) (x))	// Except everything is 32-bit on the NRF51, I think.

// Device pins.

#define USB_TX 24
#define USB_RX 25
#define BUTTON_A 17
#define BUTTON_B 26

/*
#define I2C_SDA	30				
#define I2C_SCL 0
*/

// Interrupts

#define SVC_IRQ -5
#define PENDSV_IRQ -2

/*
#define UART_IRQ 2
#define I2C_IRQ	3
#define TIMER1_IRQ 9
*/

// System registers.

#define SCB_SHPR				ARRAY(0xE000ED1C)
#define SCB_ICSR				ADDR(0xE000ED04)

#define NVIC_ISER				ARRAY(0xE000E100)
#define NVIC_ICER				ARRAY(0xE000E180)
#define NVIC_ISPR				ARRAY(0xE000E200)
#define NVIC_ICPR				ARRAY(0xE000E280)
#define NVIC_IPR				ARRAY(0xE000E400)

#define POWER_RAMON				ADDR(0x40000514)

#define CLOCK_LFCLKSRC			ADDR(0x40000518)
#define CLOCK_LFCLKSTARTED		ADDR(0x40000104)
#define CLOCK_LFCLKSTART		ADDR(0x40000008)

#define LFCLKSRC_RC 0

#define MPU_DISABLEINDEBUG		ADDR(0x40000608)
#define PENDSV 28

// GPIO

//#define GPIO_BASE				ADDR(0x50000000)

#define GPIO_OUT				ADDR(0x50000504)
#define GPIO_OUTSET				ADDR(0x50000508)
#define GPIO_OUTCLR				ADDR(0x5000050c)
#define GPIO_IN					ADDR(0x50000510)
#define GPIO_DIR				ADDR(0x50000514)
#define GPIO_DIRSET				ADDR(0x50000518)
#define GPIO_DIRCLR				ADDR(0x5000051c)

#define GPIO_PINCNF				ARRAY(0x50000700)

#define GPIO_PINCNF_PULL_Pos	2
#define GPIO_PINCNF_PULL_Msk	(0x3 << 2)
#define GPIO_Pullup				(0x3)

#define GPIO_PINCNF_DRIVE_Pos	8
#define GPIO_PINCNF_DRIVE_Msk	(0x7 << 8)
#define GPIO_S0D1				0x6

void set_priority(int irq, unsigned priority);
void enable_irq(int irq);
void disable_ireq(int irq);
void clear_pending(int irq);

#define pause()					asm volatile("wfe")

#define nop()					asm volatile("nop")
#define intr_disable()			asm volatile("cpsid i")