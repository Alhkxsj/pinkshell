# 终端工具箱 - Pinkshell

<p align="center">
  <img src="https://raw.githubusercontent.com/Alhkxsj/pinkshell/main/assets/logo.png" alt="Pinkshell Logo" width="300">
</p>

## 🌸 项目简介

终端工具箱（Pinkshell）是一款专为Termux设计的实用工具集，提供便捷的系统管理功能和个性化体验。项目采用粉色主题设计，包含多种实用工具和快捷命令，让您的移动终端操作更加高效优雅。

## 📦 安装指南

### 一键安装命令

```bash
curl -fsSL https://raw.githubusercontent.com/Alhkxsj/pinkshell/main/install.sh | bash
```

### 手动安装步骤

1. 确保已安装curl工具：
   ```bash
   pkg update && pkg install curl
   ```

2. 下载安装脚本：
   ```bash
   curl -O https://raw.githubusercontent.com/Alhkxsj/pinkshell/main/install.sh
   ```

3. 运行安装脚本：
   ```bash
   bash install.sh
   ```

4. 完成安装后，重启Termux或执行：
   ```bash
   source ~/.bashrc
   ```

## 🚀 使用方法

安装完成后，只需在Termux中输入以下命令：

```bash
泠
```

即可启动主菜单界面，访问所有功能。

### 常用快捷命令

| 命令    | 功能描述               |
|---------|------------------------|
| `泠`    | 启动工具箱主菜单       |
| `更新`  | 更新所有系统软件包     |
| `清理`  | 清理软件包缓存         |
| `存储`  | 查看磁盘使用情况       |

## 🛠️ 功能列表

1. **系统工具**
   - 软件包更新
   - 缓存清理
   - 存储空间查看
   - 系统信息查看

2. **实用工具**
   - 网络诊断
   - 文件管理
   - 进程管理

3. **个性化设置**
   - 主题切换
   - 欢迎语定制
   - 动画效果控制

## 📂 项目结构

```
pinkshell/
├── README.md           # 项目说明文件
├── bin
│   ├── menu.sh         # 主菜单程序
│   └── tools_install.sh # 工具安装器
├── install.sh          # 安装脚本
└── lib
    └── termux_utils.sh # 工具库函数
```

## 🌈 主题预览

![Pinkshell 主题预览](https://raw.githubusercontent.com/Alhkxsj/pinkshell/main/assets/preview.png)

## ❓ 常见问题

### 安装失败怎么办？
- 确保网络连接正常
- 尝试使用备用安装源：
  ```bash
  bash -c "$(curl -fsSL https://cdn.jsdelivr.net/gh/Alhkxsj/pinkshell/install.sh)"
  ```

### 如何更新工具箱？
```bash
更新
```

### 如何卸载工具箱？
1. 删除安装目录：
   ```bash
   rm -rf ~/pinkshell
   ```
2. 编辑 `~/.bashrc` 文件，移除所有包含 "pinkshell" 的行

## 💖 贡献指南

欢迎提交PR或Issue！贡献前请确保：
1. 代码符合Shell脚本规范
2. 新功能添加相应文档说明
3. 保持粉色主题风格一致

## 📜 许可协议

本项目采用 [MIT License](LICENSE) 开源协议

---

> **温馨提示**：工具箱专为Termux设计，在标准Linux环境下可能需要调整才能正常运行