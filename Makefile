# STM32 Makefile (GCC ARM)
# 支持 STM32F103C8 (BluePill) / STM32F401 等

# 芯片型号
CHIP = STM32F103C8
CPU = cortex-m3

# 工具链
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

# 编译选项
CFLAGS = -mcpu=$(CPU) -mthumb -Wall -fno-common -ffunction-sections -fdata-sections
CFLAGS += -MD -MP -MF $(BUILD_DIR)/$(TARGET).d
CFLAGS += -g3 -O0

# 链接选项
LDSCRIPT = STM32F103C8TX.ld
LDFLAGS = -mcpu=$(CPU) -mthumb -T$(LDSCRIPT)
LDFLAGS += -specs=nosys.specs -Wl,--gc-sections
LDFLAGS += -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

# 源文件
SRC = $(wildcard Src/*.c) $(wildcard Src/*.s)
OBJ = $(SRC:.c=.o) $(SRC:.s=.o)
OBJ := $(OBJ:%.s=%.o)

# 头文件路径
INC = -I Inc -IDrivers/CMSIS/Include -IDrivers/CMSIS/Device

# 目标
TARGET = firmware
BUILD_DIR = Build

.PHONY: all clean flash

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INC) -c $< -o $@

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(AS) $(CFLAGS) $(INC) -c $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(CP) -O binary $< $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/$(TARGET).elf
	$(CP) -O ihex $< $@

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

# 烧录 (需要 openocd)
flash: $(BUILD_DIR)/$(TARGET).elf
	openocd -f interface/stlink.cfg -f target/stm32f1.cfg \
		-c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"
