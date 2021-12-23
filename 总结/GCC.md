# GCC

GCC 原名为 **GNU C 语言编译器**（**GNU C Compiler**），只能处理 C 语言。但其很快扩展，变得可处理 C++，后来又扩展为能够支持更多编程语言，如 Fortran、Pascal、Objective -C、Java、Ada、Go 以及各类处理器架构上的汇编语言等，所以改名 **GNU 编译器套件**（**GNU Compiler Collection**）

## include 目录

搜索顺序是：

1. `#include` 引号包含的文件
2. `-iquote` 指定的目录，只用于引号 `#include`
3. `-I` 指定的目录
4. 环境变量 `CPATH` 指定的目录
5. `-isystem` 指定的目录
6. 环境变量 `C_INCLUDE_PATH` 指定的目录
7. 系统默认的 `include` 目录