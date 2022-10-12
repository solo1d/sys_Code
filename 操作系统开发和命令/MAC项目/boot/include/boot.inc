;------------------ loader 和 kernel ---------------------
LOADER_BASE_ADDR  equ 0x900   ;; loader 从硬盘读取出来后，放到 0x900 内存地址
LOADER_START_SECTOR equ 0x2   ;; 定义 loader 在硬盘上逻辑扇区地址， LAB地址 , 0x2 表示第二个扇区

