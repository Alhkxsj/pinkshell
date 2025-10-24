#!/bin/bash
# Pinkshell Installer

set -e

PINK='\033[1;35m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
CYAN='\033[1;36m'
RED='\033[1;31m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${PINK}"
    cat << "EOF"
   ██████╗ ██╗███╗   ██╗██╗  ██╗███████╗██╗  ██╗███████╗██╗     
  ██╔════╝ ██║████╗  ██║██║ ██╔╝██╔════╝██║  ██║██╔════╝██║     
  ██║  ███╗██║██╔██╗ ██║█████╔╝ ███████╗███████║█████╗  ██║     
  ██║   ██║██║██║╚██╗██║██╔═██╗ ╚════██║██╔══██║██╔══╝  ██║     
  ╚██████╔╝██║██║ ╚████║██║  ██╗███████║██║  ██║███████╗███████╗
   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝
   ███████╗██╗  ██╗███████╗██╗     ██╗     
   ██╔════╝██║  ██║██╔════╝██║     ██║     
   ███████╗███████║█████╗  ██║     ██║     
   ╚════██║██╔══██║██╔══╝  ██║     ██║     
   ███████║██║  ██║███████╗███████╗███████╗
   ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${PINK}[Pinkshell] 终端工具箱安装程序 v4.5${NC}"
    echo -e "${CYAN}作者: 快手啊泠好困想睡觉${NC}"
    echo
}

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log "检查系统依赖..."
    
    local missing_deps=()
    for cmd in curl pkg; do
        if ! command -v "$cmd" &>/dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        warn "缺少依赖: ${missing_deps[*]}"
        log "安装系统依赖..."
        pkg update -y && pkg install -y "${missing_deps[@]}" || {
            error "依赖安装失败"
            return 1
        }
    fi
    
    return 0
}

download_file() {
    local url="$1"
    local dest="$2"
    local retries=3
    local timeout=30
    
    for ((i=1; i<=retries; i++)); do
        if curl -fsSL --connect-timeout "$timeout" -o "$dest" "$url"; then
            return 0
        fi
        warn "下载失败 (尝试 $i/$retries): $url"
        sleep 2
    done
    
    error "无法下载文件: $url"
    return 1
}

create_directories() {
    log "创建目录结构..."
    
    local dirs=(
        "$HOME/pinkshell"
        "$HOME/pinkshell/bin"
        "$HOME/pinkshell/lib"
        "$HOME/pinkshell/lib/modules"
        "$HOME/pinkshell/assets"
        "$HOME/.pinkshell"
        "$HOME/.pinkshell/.config"
        "$HOME/.pinkshell/logs"
    )
    
    for dir in "${dirs[@]}"; do
        if ! mkdir -p "$dir"; then
            error "无法创建目录: $dir"
            return 1
        fi
    done
    
    return 0
}

download_core_files() {
    log "下载核心文件..."
    
    local base_url="https://raw.githubusercontent.com/Alhkxsj/pinkshell/main"
    local files=(
        "bin/pinkshell.sh"
        "bin/menu.sh"
        "bin/tools_install.sh"
        "bin/search_utils.sh"
        "lib/termux_utils.sh"
        "lib/modules/core.sh"
        "lib/modules/system.sh"
        "lib/modules/network.sh"
        "lib/modules/development.sh"
        "lib/modules/entertainment.sh"
        "lib/modules/personalization.sh"
        "assets/pinkshell_ascii.txt"
        "assets/terminal_ascii.txt"
    )
    
    for file in "${files[@]}"; do
        local dest="$HOME/pinkshell/$file"
        local url="$base_url/$file"
        
        log "下载: $file"
        if ! download_file "$url" "$dest"; then
            local backup_url="https://cdn.jsdelivr.net/gh/Alhkxsj/pinkshell/$file"
            warn "尝试备用源: $backup_url"
            download_file "$backup_url" "$dest" || {
                error "关键文件下载失败: $file"
                return 1
            }
        fi
        
        if [[ "$file" == bin/*.sh ]] || [[ "$file" == lib/modules/*.sh ]]; then
            chmod +x "$dest"
        fi
    done
    
    touch "$HOME/pinkshell/playlist.txt"
    touch "$HOME/.pinkshell/.config/config.conf"
    
    return 0
}

create_fallback_commands() {
    log "创建备用命令..."
    
    cat > "$HOME/pinkshell/bin/termux-change-color" << 'EOF'
#!/bin/bash
# termux-change-color 模拟实现

show_help() {
    echo "用法: termux-change-color [选项]"
    echo "选项:"
    echo "  -s, --scheme SCHEME    设置颜色方案"
    echo "  -h, --help            显示帮助信息"
    echo ""
    echo "可用方案: pink, purple, blue, green, dark, light"
}

case "$1" in
    -s|--scheme)
        case "$2" in
            pink) echo "切换到粉色主题" ;;
            purple) echo "切换到紫色主题" ;;
            blue) echo "切换到蓝色主题" ;;
            green) echo "切换到绿色主题" ;;
            dark) echo "切换到深色主题" ;;
            light) echo "切换到浅色主题" ;;
            *) echo "未知颜色方案: $2" ;;
        esac
        ;;
    -h|--help) show_help ;;
    *) show_help ;;
esac
EOF

    cat > "$HOME/pinkshell/bin/termux-font" << 'EOF'
#!/bin/bash
# termux-font 模拟实现

show_help() {
    echo "用法: termux-font [选项]"
    echo "选项:"
    echo "  -f, --font FONT    设置字体"
    echo "  -l, --list         列出可用字体"
    echo "  -h, --help         显示帮助信息"
}

case "$1" in
    -f|--font)
        echo "切换到字体: $2 (需要重启Termux生效)"
        ;;
    -l|--list)
        echo "可用字体:"
        echo "  - FiraCode"
        echo "  - Meslo" 
        echo "  - SourceCodePro"
        echo "  - Hack"
        ;;
    -h|--help) show_help ;;
    *) show_help ;;
esac
EOF

    chmod +x "$HOME/pinkshell/bin/termux-change-color" "$HOME/pinkshell/bin/termux-font"
}

setup_shell_environment() {
    log "配置shell环境..."
    
    local shell_rc_files=("$HOME/.bashrc" "$HOME/.zshrc")
    local pinkshell_config=$(cat << 'EOF'

# ===== Pinkshell 环境配置 =====
export PUMPSHELL_HOME="$HOME/pinkshell"
export PATH="$PATH:$PUMPSHELL_HOME/bin"

# 加载工具库
[ -f "$PUMPSHELL_HOME/lib/termux_utils.sh" ] && source "$PUMPSHELL_HOME/lib/termux_utils.sh"

# 主命令别名
alias 泠='bash $PUMPSHELL_HOME/bin/pinkshell.sh'
alias 更新='pkg update && pkg upgrade -y'
alias 清理='pkg clean'
alias 存储='df -h'
alias 进程='ps aux'

# zsh特定配置
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit && compinit
    setopt NO_NOMATCH
fi

# 启动问候语
echo -e "\033[1;35m🌸 Pinkshell 终端工具箱已加载! \033[0m"
echo -e "\033[1;36m输入 '泠' 启动工具箱\033[0m"
# ===== Pinkshell 配置结束 =====

EOF
)

    for rc_file in "${shell_rc_files[@]}"; do
        if [ -f "$rc_file" ]; then
            if grep -q "Pinkshell" "$rc_file"; then
                sed -i '/# ===== Pinkshell/,/# ===== Pinkshell 配置结束 =====/d' "$rc_file"
            fi
            echo "$pinkshell_config" >> "$rc_file"
            log "已配置: $rc_file"
        else
            echo "$pinkshell_config" > "$rc_file"
            log "已创建: $rc_file"
        fi
    done
}

post_install_setup() {
    log "进行安装后配置..."
    
    cat > "$HOME/pinkshell/version" << EOF
PUMPSHELL_VERSION=4.5
INSTALL_DATE=$(date +%Y-%m-%d)
INSTALL_TIME=$(date +%H:%M:%S)
EOF

    find "$HOME/pinkshell/bin" -name "*.sh" -exec chmod +x {} \;
    find "$HOME/pinkshell/lib/modules" -name "*.sh" -exec chmod +x {} \;
    
    touch "$HOME/.pinkshell/logs/install.log"
    echo "$(date): Pinkshell 安装完成" >> "$HOME/.pinkshell/logs/install.log"
}

run_tools_installer() {
    log "安装必要工具..."
    
    if [ -f "$HOME/pinkshell/bin/tools_install.sh" ]; then
        if bash "$HOME/pinkshell/bin/tools_install.sh"; then
            log "工具安装完成"
        else
            warn "工具安装器执行失败，但将继续安装"
        fi
    else
        warn "工具安装器未找到，跳过工具安装"
    fi
}

verify_installation() {
    log "验证安装..."
    
    local missing_files=()
    local essential_files=(
        "$HOME/pinkshell/bin/pinkshell.sh"
        "$HOME/pinkshell/bin/menu.sh"
        "$HOME/pinkshell/lib/modules/core.sh"
    )
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -ne 0 ]; then
        error "缺少必要文件:"
        printf '%s\n' "${missing_files[@]}"
        return 1
    fi
    
    return 0
}

show_installation_result() {
    echo
    echo -e "${PINK}╔══════════════════════════════════════╗${NC}"
    echo -e "${PINK}║          🎀 安装完成! 🎀            ║${NC}"
    echo -e "${PINK}╚══════════════════════════════════════╝${NC}"
    echo
    echo -e "${GREEN}✓ Pinkshell 终端工具箱安装成功!${NC}"
    echo
    echo -e "${CYAN}使用方法:${NC}"
    echo -e "  ${YELLOW}泠${NC}          - 启动工具箱主菜单"
    echo -e "  ${YELLOW}更新${NC}        - 更新系统软件包"
    echo -e "  ${YELLOW}清理${NC}        - 清理系统缓存"
    echo -e "  ${YELLOW}存储${NC}        - 查看磁盘空间"
    echo
    echo -e "${CYAN}支持 shell:${NC}"
    echo -e "  ${GREEN}✓ Bash${NC}"
    echo -e "  ${GREEN}✓ Zsh${NC}"
    echo
    echo -e "${YELLOW}提示: 重新启动Termux或执行: source ~/.bashrc${NC}"
    echo
}

main() {
    show_banner
    log "开始安装 Pinkshell..."
    
    if ! check_dependencies; then
        error "依赖检查失败"
        exit 1
    fi
    
    if ! create_directories; then
        error "目录创建失败"
        exit 1
    fi
    
    if ! download_core_files; then
        error "文件下载失败"
        exit 1
    fi
    
    create_fallback_commands
    setup_shell_environment
    post_install_setup
    run_tools_installer
    
    if verify_installation; then
        show_installation_result
    else
        error "安装验证失败"
        exit 1
    fi
}

main "$@"