CC			= arm-none-eabi-gcc
AS			= arm-none-eabi-as
GXX			= arm-none-eabi-g++
OC			= arm-none-eabi-objcopy
OD			= arm-none-eabi-objdump
LD			= arm-none-eabi-ld
SZ			= arm-none-eabi-size

CPU			= -mcpu=cortex-m0 -mthumb

ASFLAGS		+= -Wall -g

CFLAGS		+= $(CPU) 
CFLAGS		+= $(INC)
CFLAGS		+= -Wall -g
#CFLAGS		+= -ffunction-sections -fdata-sections

GXXFLAGS	+= $(CPU)
GXXFLAGS	+= $(INC)
GXXFLAGS	+= -Wall -g

LDFLAGS		+= -nostdlib -nostdinc

TARGET		= program

BINDIR		= bin
OBJDIR		= obj
SRCDIR		= src
INCDIR		= inc

OBJEXT		= o
SRCEXT		= c

INC			= -I$(INCDIR)

SOURCES		= $(shell find $(SRCDIR) -type f -name *.c)

OBJ			+= $(patsubst $(SRCDIR)/%, $(OBJDIR)/%, $(SOURCES:$(SRCEXT)=$(OBJEXT)))
OBJ			+= $(patsubst $(SRCDIR)/%, $(OBJDIR)/%, $(SOURCES:$(SRCEXT)=$(OBJEXT)))

LDSCRIPT	= -T$(INCDIR)/tutorialLink.ld

all: directories $(BINDIR)/$(TARGET).bin $(BINDIR)/$(TARGET).hex

debug:
	@echo $(OBJ)

directories:
	@mkdir -p $(BINDIR)
	@mkdir -p $(OBJDIR)
	@mkdir -p $(SRCDIR)
	@mkdir -p $(INCDIR)
	
$(BINDIR)/$(TARGET).hex: $(BINDIR)/$(TARGET).elf
	$(OC) -O ihex $< $@
	
$(BINDIR)/$(TARGET).bin: $(BINDIR)/$(TARGET).elf
	$(OC) -O binary $< $@

$(BINDIR)/$(TARGET).elf: $(OBJ)
	$(LD) $(LDSCRIPT) $(LDFLAGS) $^ -o $@
	$(SZ) $@
	
$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.cpp
	$(GXX) $(GXXFLAGS) -c $^ -o $@

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	$(CC) $(CFLAGS) -c $^ -o $@

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.s
	$(AS) $(ASFLAGS) -c $^ -o $@

clean:
	rm -f -- $(OBJ) $(BINDIR)/$(TARGET).* 2>/dev/null || true

.PHONY: all debug directories clean