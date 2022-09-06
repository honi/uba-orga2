CC=c99
CFLAGS=-Wall -Wextra -pedantic -O0 -g -lm -no-pie -z noexecstack
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF
LD=ld

OUTPUT_PATH := bin
OUTPUT_FILENAME := app
SRC_C := $(wildcard *.c)
SRC_ASM := $(wildcard *.asm)
HEADERS := $(wildcard *.h)
OBJS := $(patsubst %.c,%.o,$(SRC_C) $(patsubst %.asm,%.o,$(SRC_ASM)))

.PHONY: all clean

all: app

app: $(OBJS)
	@mkdir -p $(OUTPUT_PATH)
ifeq ($(strip $(SRC_C)),)
	$(LD) $^ -o $(OUTPUT_PATH)/$(OUTPUT_FILENAME)
else
	$(CC) $(CFLAGS) $^ -o $(OUTPUT_PATH)/$(OUTPUT_FILENAME)
endif

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm $(HEADERS)
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -rf $(OUTPUT_PATH)
