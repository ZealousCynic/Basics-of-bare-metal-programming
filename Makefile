CC			= arm-none-eabi-gcc
AS			= arm-none-eabi-as
GXX			= arm-none-eabi-g++
OC			= arm-none-eabi-objcopy
OD			= arm-none-eabi-objdump
LD			= arm-none-eabi-ld
SZ			= arm-none-eabi-size

COMMON		= -Wall -g
CPU			= -mcpu=cortex-m0 -mthumb
ARC			= -march=armv6-m
OPT 		+= -g3
#OPT		+= -O3

ASFLAGS		+= $(COMMON)
ASFLAGS		+= $(CPU)
ASFLAGS		+= $(ARC)
ASFLAGS		+= $(OPT)

CFLAGS		+= $(COMMON)
CFLAGS		+= $(CPU) 
CFLAGS		+= $(ARC)
CFLAGS		+= $(OPT)
CFLAGS		+= $(INC)
CFLAGS 		+= -mfloat-abi=soft
#CFLAGS		+= -ffunction-sections -fdata-sections

GXXFLAGS	+= $(COMMON)
GXXFLAGS	+= $(CPU)
GXXFLAGS	+= $(INC)

LDFLAGS		+= -lgcc -nostdlib
LDFLAGS		+= -O -g -Wall

# Some of the linker flags below must be passed to gcc rather than ld.

#LDFLAGS += -Xlinker -Map=$(TARGETDIR)/$(TARGET).map
#LDFLAGS += -mthumb -mabi=aapcs
#LDFLAGS += -mcpu=cortex-m0
#LDFLAGS += --specs=nano.specs -lc -lnosys
#LDFLAGS += -Wl,--gc-sections

TARGET		= program

BINDIR		= bin
OBJDIR		= obj
SRCDIR		= src
INCDIR		= inc

OBJEXT		= o
SRCEXT		= c

INC			= -I$(INCDIR)

SOURCES		:= src/blinker.c
SOURCES		+= $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))


OBJ			:= $(patsubst $(SRCDIR)/%, $(OBJDIR)/%, $(SOURCES:$(SRCEXT)=$(OBJEXT)))
#OBJ			+= $(patsubst $(SRCDIR)/%, $(OBJDIR)/%, $(SOURCES:$(SRCEXT)=$(OBJEXT)))

LDSCRIPT	= -Tsrc/tutorialLink.ld

all: directories $(BINDIR)/$(TARGET).bin $(BINDIR)/$(TARGET).hex run .debug

run:
	@cp $(BINDIR)/$(TARGET).hex E:/
	
.debug: $(BINDIR)/$(TARGET).debug


debug:
	@echo "SOURCES: " $(SOURCES)
	@echo "OBJ: " $(OBJ)

directories:
	@mkdir -p $(BINDIR)
	@mkdir -p $(OBJDIR)
	@mkdir -p $(SRCDIR)
	@mkdir -p $(INCDIR)
	
$(BINDIR)/$(TARGET).hex: $(BINDIR)/$(TARGET).elf
	$(OC) -O ihex $< $@
	
$(BINDIR)/$(TARGET).bin: $(BINDIR)/$(TARGET).elf
	$(OC) -O binary $< $@
	
$(BINDIR)/$(TARGET).debug: $(BINDIR)/$(TARGET).elf
	$(OC) --only-keep-debug $< $@

#$(BINDIR)/$(TARGET).elf: $(OBJ)
#	$(LD) $(LDSCRIPT) $(LDFLAGS) $^ -o $@
#	$(SZ) $@

$(BINDIR)/$(TARGET).elf: $(OBJ)
	$(CC) $(LDSCRIPT) $(LDFLAGS) $^ -o $@ -Wl,-Map,$(BINDIR)/$(TARGET).map
	
$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.cpp
	$(GXX) $(GXXFLAGS) -c $^ -o $@

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	$(CC) $(CFLAGS) -c $^ -o $@

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.s
	$(AS) $(ASFLAGS) -c $^ -o $@

clean:
	rm -f -- $(OBJ) $(BINDIR)/$(TARGET).* 2>/dev/null || true

.PHONY: all debug directories clean