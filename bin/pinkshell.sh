#!/data/data/com.termux/files/usr/bin/bash
# Pinkshell 模块化主文件

# 加载配置
if [ -f $HOME/.pinkshell/.config/config.conf ]; then
  source $HOME/.pinkshell/.config/config.conf
fi

# 检查并创建必要的目录和文件
mkdir -p $HOME/.pinkshell/.config
if [ ! -f $HOME/.pinkshell/.config/config.conf ]; then
  touch $HOME/.pinkshell/.config/config.conf
fi

# 播放列表文件
PLAYLIST_FILE="$HOME/pinkshell/playlist.txt"
mkdir -p "$(dirname "$PLAYLIST_FILE")"
touch "$PLAYLIST_FILE"

# 颜色定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
PINK='\033[1;35m'
NC='\033[0m'

# 加载所有模块
MODULES_DIR="$HOME/pinkshell/lib/modules"

# 加载核心模块
if [ -f "$MODULES_DIR/core.sh" ]; then
  source "$MODULES_DIR/core.sh"
fi

# 加载系统工具模块
if [ -f "$MODULES_DIR/system.sh" ]; then
  source "$MODULES_DIR/system.sh"
fi

# 加载网络工具模块
if [ -f "$MODULES_DIR/network.sh" ]; then
  source "$MODULES_DIR/network.sh"
fi

# 加载开发工具模块
if [ -f "$MODULES_DIR/development.sh" ]; then
  source "$MODULES_DIR/development.sh"
fi

# 加载娱乐工具模块
if [ -f "$MODULES_DIR/entertainment.sh" ]; then
  source "$MODULES_DIR/entertainment.sh"
fi

# 加载个性化设置模块
if [ -f "$MODULES_DIR/personalization.sh" ]; then
  source "$MODULES_DIR/personalization.sh"
fi

# 加载主菜单模块
if [ -f "$MODULES_DIR/menu.sh" ]; then
  source "$MODULES_DIR/menu.sh"
fi

# 启动脚本
check_dependencies

# 检查是否从终端直接运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_menu
fi