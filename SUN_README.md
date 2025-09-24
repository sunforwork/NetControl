# SUN.sh - TXT to HTML Converter

## 概述 (Overview)

SUN.sh 是一个将 `docs` 目录下所有 `.txt` 文件转换为 HTML 文件的脚本。生成的 HTML 文件具有统一的标题"YuChen联网控分发平台"，支持 UTF-8 编码和换行显示。

SUN.sh is a script that converts all `.txt` files in the `docs` directory to HTML files with the title "YuChen联网控分发平台", UTF-8 encoding, and proper line break support.

## 功能特性 (Features)

- ✅ 统一标题：YuChen联网控分发平台
- ✅ UTF-8 编码支持，正确显示中文字符
- ✅ 保持原文本格式和换行
- ✅ 响应式设计，支持移动设备
- ✅ 保持目录结构
- ✅ 美观的界面设计
- ✅ HTML 字符转义，防止 XSS
- ✅ 生成时间戳

## 使用方法 (Usage)

### 基本使用

```bash
# 使脚本可执行
chmod +x SUN.sh

# 运行脚本
./SUN.sh
```

### 查看帮助

```bash
./SUN.sh --help
```

## 输出结果 (Output)

脚本会在 `html_output` 目录中生成对应的 HTML 文件，保持与 `docs` 目录相同的结构。

例如：
- `docs/Nexis/SUN/1.txt` → `html_output/Nexis/SUN/1.html`
- `docs/example.txt` → `html_output/example.html`

## HTML 特性 (HTML Features)

生成的 HTML 文件包含：

1. **响应式设计**：适配桌面和移动设备
2. **UTF-8 编码**：完美支持中文显示
3. **格式保持**：保留原文本的换行和空格
4. **安全转义**：HTML 特殊字符自动转义
5. **美观样式**：现代化的界面设计
6. **时间戳**：显示生成时间

## 要求 (Requirements)

- Linux/Unix 系统
- Bash shell
- 存在 `docs` 目录

## 示例 (Example)

```bash
$ ./SUN.sh
SUN.sh - TXT to HTML Converter
Converting all txt files in docs directory to HTML...
Processing: docs/Nexis/SUN/1.txt
Output: html_output/Nexis/SUN/1.html

Conversion completed!
Processed files: 1
Output directory: html_output
Done!
```

## 注意事项 (Notes)

- 生成的 `html_output` 目录已添加到 `.gitignore` 中
- 脚本会自动创建必要的输出目录
- 如果 `docs` 目录不存在，脚本会报错退出
- 支持处理任意数量的 txt 文件