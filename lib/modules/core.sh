#!/bin/bash
# Pinkshell 核心模块

set -e

declare -g RED='\033[1;31m'
declare -g GREEN='\033[1;32m' 
declare -g YELLOW='\033[1;33m'
declare -g BLUE='\033[1;34m'
declare -g PURPLE='\033[1;35m'
declare -g CYAN='\033[1;36m'
declare -g PINK='\033[1;35m'
declare -g NC='\033[0m'

declare -g PINKSHOME="${PINKSHOME:-$HOME/pinkshell}"
declare -g CONFIG_DIR="${CONFIG_DIR:-$HOME/.pinkshell/.config}"
declare -g LOG_DIR="${LOG_DIR:-$HOME/.pinkshell/logs}"
declare -g PLAYLIST_FILE="${PLAYLIST_FILE:-$PINKSHOME/playlist.txt}"

initialize_pinkshell() {
    mkdir -p "$CONFIG_DIR" "$LOG_DIR"
    
    if [ ! -f "$CONFIG_DIR/config.conf" ]; then
        cat > "$CONFIG_DIR/config.conf" << EOF
# Pinkshell 配置文件
THEME_COLOR="pink"
ENABLE_ANIMATIONS="true"
AUTO_UPDATE="false"
LOG_LEVEL="info"
EOF
    fi
    
    touch "$PLAYLIST_FILE"
}

pinkshell_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" >> "$LOG_DIR/pinkshell.log"
    
    case "$level" in
        "ERROR") echo -e "${RED}[ERROR]${NC} $message" >&2 ;;
        "WARN") echo -e "${YELLOW}[WARN]${NC} $message" >&2 ;;
        "INFO") echo -e "${GREEN}[INFO]${NC} $message" ;;
        "DEBUG") echo -e "${BLUE}[DEBUG]${NC} $message" ;;
    esac
}

handle_error() {
    local exit_code=$?
    local command="${BASH_COMMAND}"
    
    pinkshell_log "ERROR" "命令执行失败: $command (退出码: $exit_code)"
    
    case $exit_code in
        1) echo -e "${RED}错误: 一般性错误${NC}" ;;
        2) echo -e "${RED}错误: 内置命令误用${NC}" ;;
        126) echo -e "${RED}错误: 命令不可执行${NC}" ;;
        127) echo -e "${RED}错误: 命令未找到${NC}" ;;
        130) echo -e "${YELLOW}操作被用户中断${NC}" ;;
        *) echo -e "${RED}错误: 未知错误 (代码: $exit_code)${NC}" ;;
    esac
    
    return $exit_code
}

trap handle_error ERR

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

security_check() {
    local script_path="$1"
    
    if [ ! -r "$script_path" ]; then
        pinkshell_log "ERROR" "脚本不可读: $script_path"
        return 1
    fi
    
    local file_owner=$(stat -c %U "$script_path" 2>/dev/null || stat -f %Su "$script_path")
    if [ "$file_owner" != "$USER" ]; then
        pinkshell_log "WARN" "脚本所有者不是当前用户: $script_path"
    fi
    
    return 0
}

welcome_banner() {
    clear
    
    if command_exists lolcat; then
        display_cmd="lolcat -p 0.6"
    else
        display_cmd="cat"
    fi
    
    if [ -f "$PINKSHOME/assets/pinkshell_ascii.txt" ]; then
        cat "$PINKSHOME/assets/pinkshell_ascii.txt" | $display_cmd
    else
        echo -e "${PINK}"
        cat << "EOF"
  _____ _    _ _  __     _____ _          _ _ 
 |  __ (_)  | | |/ /    / ____| |        | | |
 | |__) | __| | ' / ___| (___ | |__   ___| | |
 |  ___/ '__| |  < / _ \___ \| '_ \ / _ \ | |
 | |   | |  | | . \  __/____) | | | |  __/ | |
 |_|   |_|  |_|_|\_\___|_____/|_| |_|\___|_|_|
    _____                    _                        _ 
 |_   _|                  | |                      | |
   | | ___ _ __ _ __   ___| |___      _____  _ __ __| |
   | |/ _ \ '__| '_ \ / _ \ __\ \ /\ / / _ \| '__/ _` |
  _| |  __/ |  | | | |  __/ |_ \ V  V / (_) | | | (_| |
 |_____\___|_|  |_| |_|\___|\__| \_/\_/ \___/|_|  \__,_|
EOF
        echo -e "${NC}"
    fi
    
    if command_exists lolcat; then
        echo "◆ 作者：快手啊泠好困想睡觉 ◆" | lolcat
        echo "► 版本：v4.5 - 修复增强版 ◄" | lolcat
        echo "► 日期：$(date +'%Y-%m-%d %H:%M') ◄" | lolcat
    else
        echo -e "${CYAN}◆ 作者：${YELLOW}快手啊泠好困想睡觉 ${CYAN}◆${NC}"
        echo -e "${GREEN}► 版本：v4.5 - 修复增强版 ◄${NC}"
        echo -e "${GREEN}► 日期：$(date +'%Y-%m-%d %H:%M') ◄${NC}"
    fi
    echo
}

get_system_info() {
    local info=()
    
    if command_exists uname; then
        info+=("设备: $(uname -npo 2>/dev/null || uname -s)")
    fi
    
    if command_exists uname; then
        info+=("内核: $(uname -r)")
    fi
    
    if command_exists df; then
        local available_space=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')
        info+=("存储: ${available_space:-未知} 可用")
    fi
    
    if command_exists free; then
        local free_memory=$(free -m 2>/dev/null | awk 'NR==2 {print $7}')
        info+=("内存: ${free_memory:-未知}MB 可用")
    fi
    
    if [ -f "$PREFIX/etc/termux/version" ]; then
        local termux_version=$(cat "$PREFIX/etc/termux/version")
        info+=("Termux: $termux_version")
    fi
    
    printf '%s\n' "${info[@]}"
}

show_easter_egg() {
    clear
    welcome_banner
    
    echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
    echo -e "${PINK}║           🌸 Pinkshell 彩蛋 🌸         ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"
    echo ""
    
    local colors=("$RED" "$YELLOW" "$GREEN" "$CYAN" "$BLUE" "$PURPLE")
    for i in {1..3}; do
        for color in "${colors[@]}"; do
            echo -en "${color}✨ ${NC}"
            sleep 0.1
        done
        echo -en "\r"
    done
    
    echo -e "\n${CYAN}🎉 欢迎使用 Pinkshell 终端工具箱！${NC}"
    echo -e "${YELLOW}作者: 快手啊泠好困想睡觉${NC}"
    echo -e "${GREEN}版本: v4.5 - 修复增强版${NC}"
    echo -e "${PINK}══════════════════════════════════════${NC}"
    
    echo -e "\n${BLUE}🖥️  系统信息:${NC}"
    get_system_info | while read -r line; do
        echo -e "  ${CYAN}$line${NC}"
    done
    
    echo -e "\n${PINK}🎮 彩蛋小游戏${NC}"
    echo -e "${YELLOW}猜猜我现在在想什么？${NC}"
    echo -e "${CYAN}提示: 是一个数字 (1-10)${NC}"
    
    local secret_number=$((RANDOM % 10 + 1))
    local attempts=0
    local max_attempts=3
    
    while [ $attempts -lt $max_attempts ]; do
        read -p "$(echo -e "${GREEN}请输入你的猜测 (剩余 $((max_attempts - attempts)) 次机会): ${NC}")" guess
        
        if ! [[ "$guess" =~ ^[0-9]+$ ]] || [ "$guess" -lt 1 ] || [ "$guess" -gt 10 ]; then
            echo -e "${RED}请输入 1-10 之间的数字！${NC}"
            continue
        fi
        
        attempts=$((attempts + 1))
        
        if [ "$guess" -eq "$secret_number" ]; then
            echo -e "${GREEN}🎉 恭喜你猜对了！${NC}"
            echo -e "${YELLOW}你真是太厉害了！${NC}"
            break
        elif [ "$guess" -lt "$secret_number" ]; then
            echo -e "${CYAN}太小了！再试一次${NC}"
        else
            echo -e "${CYAN}太大了！再试一次${NC}"
        fi
        
        if [ $attempts -eq $max_attempts ]; then
            echo -e "${YELLOW}答案是: $secret_number${NC}"
            echo -e "${PINK}没关系，下次一定可以！${NC}"
        fi
    done
    
    local quotes=(
        "代码如诗，逻辑如画，编程是艺术与科学的完美结合。"
        "在0和1的世界里，你是唯一的变量。"
        "每个bug都是成长的机会，每个错误都是进步的阶梯。"
        "编程不是工作，而是创造世界的魔法。"
        "一行代码，一份热爱；一个算法，一份执着。"
        "代码改变世界，程序创造未来。"
        "程序是写给人读的，只是顺便能在机器上运行。"
        "编程是一种思想，而不是一种语言。"
    )
    
    local blessings=(
        "愿你的代码永远没有bug！"
        "愿你的程序运行流畅如飞！"
        "愿你的创意无限迸发！"
        "愿你的技术日益精进！"
        "愿你享受编程的每一刻！"
        "愿你成为代码世界的魔法师！"
    )
    
    local random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
    local random_blessing=${blessings[$RANDOM % ${#blessings[@]}]}
    
    echo -e "\n${PURPLE}「 ${random_quote} 」${NC}"
    echo -e "\n${PINK}💝 ${random_blessing} ${NC}"
    
    echo -e "\n${RED}❤${YELLOW}🧡${GREEN}💚${CYAN}💙${BLUE}💜${PURPLE}💖${NC}"
    echo -e "${CYAN}感谢使用 Pinkshell！${NC}"
    echo -e "${GREEN}按任意键返回主菜单...${NC}"
    read -n 1 -s
}

check_pinkshell_dependencies() {
    local missing_tools=()
    local recommended_tools=("curl" "wget" "git" "python" "node" "mpv" "nmap")
    
    for tool in "${recommended_tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        pinkshell_log "WARN" "推荐工具未安装: ${missing_tools[*]}"
        echo -e "${YELLOW}推荐安装以下工具以获得完整功能:${NC}"
        printf ' - %s\n' "${missing_tools[@]}"
        echo
        read -p "是否立即安装这些工具? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pkg update && pkg install -y "${missing_tools[@]}"
        fi
    fi
}

load_config() {
    if [ -f "$CONFIG_DIR/config.conf" ]; then
        source "$CONFIG_DIR/config.conf"
    else
        THEME_COLOR="pink"
        ENABLE_ANIMATIONS="true"
        AUTO_UPDATE="false"
        LOG_LEVEL="info"
    fi
}

save_config() {
    cat > "$CONFIG_DIR/config.conf" << EOF
# Pinkshell 配置文件
THEME_COLOR="$THEME_COLOR"
ENABLE_ANIMATIONS="$ENABLE_ANIMATIONS"
AUTO_UPDATE="$AUTO_UPDATE"
LOG_LEVEL="$LOG_LEVEL"
EOF
}

initialize_pinkshell
load_config

export -f welcome_banner
export -f show_easter_egg
export -f get_system_info
export -f pinkshell_log
export -f command_exists
export -f security_check