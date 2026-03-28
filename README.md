# STM32 开发环境配置

## 目录结构
```
stm32_project/
├── Makefile           # 编译规则
├── STM32F103C8TX.ld   # 链接脚本
├── Src/
│   ├── main.c         # 主程序
│   └── startup.s      # 启动文件
└── Inc/
    └── main.h         # 头文件
```

## 安装工具链

```bash
# Linux/macOS
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi

# macOS
brew install ARM gcc

# Windows (使用WSL)
sudo apt install gcc-arm-none-eabi
```

## 编译

```bash
cd ~/stm32_project
make
```

## 烧录

需要ST-Link和OpenOCD：

```bash
# 安装OpenOCD
sudo apt install openocd

# 接线
# ST-Link VCC -> 3.3V
# ST-Link GND -> GND
# ST-Link SWCLK -> SWCLK
# ST-Link SWDIO -> SWDIO

# 烧录
make flash
```

## 硬件

STM32F103C8 (BluePill):
- LED: PC13
- 晶振: 8MHz

## 串口查看日志

```bash
# 查找串口
ls /dev/ttyUSB*

# 查看输出
screen /dev/ttyUSB0 115200
```

## 可选：使用HAL库

需要STM32CubeMX生成代码，或从GitHub下载HAL库。
