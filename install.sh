#!/bin/bash
# Pinkshell Installer

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

echo -e "${YELLOW}Checking dependencies...${NC}"
command -v curl &>/dev/null || {
    echo -e "${YELLOW}Installing curl...${NC}"
    pkg update -y && pkg install -y curl
}

mkdir -p "$HOME/pinkshell/bin" "$HOME/pinkshell/lib"

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

sed -i 's|~|$HOME|g' "$HOME/pinkshell/bin/menu.sh"
sed -i 's|~|$HOME|g' "$HOME/pinkshell/bin/tools_install.sh"

add_to_shellrc() {
    local file="$1"
    echo -e "${YELLOW}Updating $file...${NC}"
    
    # Remove old pinkshell config if exists
    if grep -q 'Pinkshell Environment' "$file"; then
        sed -i '/# ===== Pinkshell Environment =====/,/# ===== End Pinkshell Config =====/d' "$file"
    fi
    
    # Add new pinkshell config
    cat >> "$file" << 'EOF'

# ===== Pinkshell Environment =====
export PATH="$PATH:$HOME/pinkshell/bin"
[ -f "$HOME/pinkshell/lib/termux_utils.sh" ] && source "$HOME/pinkshell/lib/termux_utils.sh"
alias 泠='bash $HOME/pinkshell/bin/menu.sh'
alias 更新='pkg update && pkg upgrade -y'
alias 清理='pkg clean'
alias 存储='df -h'
# ===== End Pinkshell Config =====

EOF
}

add_to_shellrc "$HOME/.bashrc"
add_to_shellrc "$HOME/.zshrc"

echo -e "${YELLOW}Applying environment changes...${NC}"
source "$HOME/.bashrc" 2>/dev/null || true
source "$HOME/.zshrc" 2>/dev/null || true

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

echo -e "${YELLOW}Installing required tools...${NC}"
bash "$HOME/pinkshell/bin/tools_install.sh"

echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${BLUE}To launch, type: 泠${NC}"
