#!/bin/bash
# Pinkshell Installer by Alhkxsj

# 颜色定义
PINK='\033[1;35m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

clear
echo -e "${PINK}"
echo "   ██████╗ ██╗   ██╗ ██████╗ ██╗  ██╗"
echo "  ██╔════╝ ██║   ██║██╔═══██╗██║  ██║"
echo "  ██║  ███╗██║   ██║██║   ██║███████║"
echo "  ██║   ██║██║   ██║██║   ██║██╔══██║"
echo "  ╚██████╔╝╚██████╔╝╚██████╔╝██║  ██║"
echo "   ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${PINK}[Pinkshell] Installer Starting...${NC}"

# 检查依赖项
echo -e "${YELLOW}Checking dependencies...${NC}"
command -v curl &>/dev/null || {
    echo -e "${YELLOW}Installing curl...${NC}"
    pkg update -y && pkg install -y curl
}

# 创建目录
mkdir -p "$HOME/pinkshell/bin" "$HOME/pinkshell/lib"

# 下载文件
echo -e "${YELLOW}Downloading main scripts...${NC}"
base_url="https://raw.githubusercontent.com/Alhkxsj/pinkshell/main"

download_file() {
    local path=$1
    local dest=$2
    echo -e "${BLUE}Downloading: $path${NC}"
    curl -fsSL -o "$dest" "${base_url}${path}" || {
        echo -e "${YELLOW}Failed, trying backup...${NC}"
        curl -fsSL -o "$dest" "https://cdn.jsdelivr.net/gh/Alhkxsj/pinkshell${path}"
    }
}

download_file "/bin/menu.sh" "$HOME/pinkshell/bin/menu.sh"
download_file "/bin/tools_install.sh" "$HOME/pinkshell/bin/tools_install.sh"
download_file "/lib/termux_utils.sh" "$HOME/pinkshell/lib/termux_utils.sh"

chmod +x "$HOME/pinkshell/bin"/*.sh "$HOME/pinkshell/lib"/*.sh

# 修复路径
sed -i 's|~|$HOME|g' "$HOME/pinkshell/bin/menu.sh"
sed -i 's|~|$HOME|g' "$HOME/pinkshell/bin/tools_install.sh"

# 自动写入配置
add_to_shellrc() {
    local file="$1"
    grep -q 'pinkshell' "$file" && return
    echo -e "${YELLOW}Updating $file...${NC}"
    cat >> "$file" << 'EOF'

# ===== Pinkshell Environment =====
export PATH="$PATH:$HOME/pinkshell/bin"
[ -f "$HOME/pinkshell/lib/termux_utils.sh" ] && source "$HOME/pinkshell/lib/termux_utils.sh"
alias 泠='bash $HOME/pinkshell/bin/menu.sh'
alias 更新='pkg update && pkg upgrade -y'
alias 清理='pkg clean'
alias 存储='df -h'

# Auto start menu if not already run
if [ -f "$HOME/pinkshell/bin/menu.sh" ] && [ -z "$MENU_ALREADY_RUN" ]; then
  export MENU_ALREADY_RUN=1
  bash "$HOME/pinkshell/bin/menu.sh"
fi
# ===== End Pinkshell Config =====

EOF
}

add_to_shellrc "$HOME/.bashrc"
add_to_shellrc "$HOME/.zshrc"

# 应用环境变量
echo -e "${YELLOW}Applying environment changes...${NC}"
source "$HOME/.bashrc" 2>/dev/null || true
source "$HOME/.zshrc" 2>/dev/null || true

# 安装提示
echo -e "${GREEN}"
echo "██████╗ ██╗   ██╗███████╗"
echo "██╔═══██╗██║   ██║██╔════╝"
echo "██║   ██║██║   ██║█████╗  "
echo "██║▄▄ ██║██║   ██║██╔══╝  "
echo "╚██████╔╝╚██████╔╝███████╗"
echo " ╚══▀▀═╝  ╚═════╝ ╚══════╝"
echo -e "${NC}"

echo -e "${PINK}[✓] Installed successfully!${NC}"
echo -e "${BLUE}To launch, type: 泠"
echo -e "Menu will auto-start next time you open Termux${NC}"

# 首次启动工具安装器
echo -e "${YELLOW}Installing required tools...${NC}"
bash "$HOME/pinkshell/bin/tools_install.sh"

# 延迟首次启动
echo -e "${PINK}Launching menu in 5 seconds...${NC}"
sleep 5
bash "$HOME/pinkshell/bin/menu.sh"
