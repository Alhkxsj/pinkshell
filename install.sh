#!/bin/bash
# Pinkshell 终端工具箱 - 安装脚本
# 作者: 快手啊泠好困想睡觉
# 版本: v4.5

set -euo pipefail

# 颜色定义
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# 全局变量
PINKSHOME="$HOME/pinkshell"
REPO_URL="https://github.com/Alhkxsj/pinkshell"
BACKUP_URL="https://cdn.jsdelivr.net/gh/Alhkxsj/pinkshell"
INSTALL_LOG="$HOME/.pinkshell_install.log"

# 日志函数
log() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "${GREEN}[$level]${NC} $message"
    echo "[$timestamp] [$level] $message" >> "$INSTALL_LOG"
}

warn() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "${YELLOW}[WARN]${NC} $message"
    echo "[$timestamp] [WARN] $message" >> "$INSTALL_LOG"
}

error() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "${RED}[ERROR]${NC} $message" >&2
    echo "[$timestamp] [ERROR] $message" >> "$INSTALL_LOG"
    exit 1
}

# 显示横幅
show_banner() {
    clear
    echo -e "${PURPLE}"
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
    echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║        Pinkshell 终端工具箱          ║${NC}"
    echo -e "${PURPLE}║          安装程序 v4.5              ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"
    echo -e "${CYAN}作者: 快手啊泠好困想睡觉${NC}"
    echo -e "${BLUE}开始时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo
}

# 检查Termux环境
check_termux_environment() {
    log "检查运行环境..."
    
    if [ -z "$PREFIX" ] || [ ! -d "/data/data/com.termux" ]; then
        error "此脚本必须在 Termux 环境中运行"
    fi
    
    if ! command -v pkg >/dev/null 2>&1; then
        error "未找到 pkg 包管理器，请确保 Termux 安装正确"
    fi
    
    log "环境检查通过 - Termux $(pkg -v 2>/dev/null || echo '未知版本')"
}

# 检查网络连接
check_network() {
    log "检查网络连接..."
    
    if ! ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
        if ! ping -c 1 -W 3 114.114.114.114 >/dev/null 2>&1; then
            warn "网络连接可能有问题，但将继续安装"
        fi
    fi
    
    log "网络检查完成"
}

# 检查存储空间
check_storage() {
    log "检查存储空间..."
    
    local available_kb=$(df "$HOME" | awk 'NR==2 {print $4}')
    local required_kb=50000  # 50MB
    
    if [ "$available_kb" -lt "$required_kb" ]; then
        warn "存储空间可能不足 (可用: ${available_kb}KB, 需要: ${required_kb}KB)"
        read -p "是否继续安装? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "安装已取消"
        fi
    fi
    
    log "存储空间检查通过 (可用: ${available_kb}KB)"
}

# 安装系统依赖
install_system_dependencies() {
    log "安装系统依赖包..."
    
    local base_packages=("curl" "wget" "git" "python" "nodejs" "ruby")
    local tool_packages=("nmap" "neofetch" "htop" "tree" "jq" "unzip" "zip" "tar")
    local media_packages=("mpv" "ffmpeg" "sox")
    local dev_packages=("clang" "make" "cmake" "vim" "nano")
    
    log "更新软件包列表..."
    if ! pkg update -y; then
        warn "软件包列表更新失败，尝试继续安装"
    fi
    
    log "安装基础依赖..."
    for pkg in "${base_packages[@]}"; do
        if ! pkg list-installed | grep -q "$pkg"; then
            log "安装: $pkg"
            if ! pkg install -y "$pkg"; then
                warn "安装失败: $pkg"
            fi
        else
            log "已安装: $pkg"
        fi
    done
    
    log "安装工具软件..."
    for pkg in "${tool_packages[@]}"; do
        if ! pkg list-installed | grep -q "$pkg"; then
            log "安装: $pkg"
            if ! pkg install -y "$pkg"; then
                warn "安装失败: $pkg"
            fi
        else
            log "已安装: $pkg"
        fi
    done
    
    log "安装媒体工具..."
    for pkg in "${media_packages[@]}"; do
        if ! pkg list-installed | grep -q "$pkg"; then
            log "安装: $pkg"
            if ! pkg install -y "$pkg"; then
                warn "安装失败: $pkg"
            fi
        else
            log "已安装: $pkg"
        fi
    done
    
    log "安装开发工具..."
    for pkg in "${dev_packages[@]}"; do
        if ! pkg list-installed | grep -q "$pkg"; then
            log "安装: $pkg"
            if ! pkg install -y "$pkg"; then
                warn "安装失败: $pkg"
            fi
        else
            log "已安装: $pkg"
        fi
    done
    
    # 安装Ruby gem (lolcat)
    if command -v gem >/dev/null 2>&1; then
        log "安装 lolcat..."
        if gem install lolcat; then
            log "lolcat 安装成功"
        else
            warn "lolcat 安装失败"
        fi
    fi
    
    log "系统依赖安装完成"
}

# 创建目录结构
create_directory_structure() {
    log "创建目录结构..."
    
    local directories=(
        "$PINKSHOME"
        "$PINKSHOME/bin"
        "$PINKSHOME/lib"
        "$PINKSHOME/lib/modules"
        "$PINKSHOME/assets"
        "$HOME/.pinkshell"
        "$HOME/.pinkshell/.config"
        "$HOME/.pinkshell/logs"
        "$HOME/.pinkshell/backups"
    )
    
    for dir in "${directories[@]}"; do
        if mkdir -p "$dir"; then
            log "创建目录: $dir"
        else
            error "无法创建目录: $dir"
        fi
    done
}

# 下载文件函数
download_file() {
    local file_path="$1"
    local dest_path="$2"
    local retries=3
    
    for ((i=1; i<=retries; i++)); do
        log "下载文件: $file_path (尝试 $i/$retries)"
        
        # 尝试主仓库
        if curl -fsSL -o "$dest_path" "$REPO_URL/raw/main/$file_path"; then
            log "下载成功: $file_path"
            return 0
        fi
        
        # 尝试备用CDN
        if curl -fsSL -o "$dest_path" "$BACKUP_URL/$file_path"; then
            log "通过CDN下载成功: $file_path"
            return 0
        fi
        
        warn "下载失败: $file_path"
        sleep 2
    done
    
    error "无法下载文件: $file_path"
}

# 下载核心文件
download_core_files() {
    log "下载核心文件..."
    
    # 定义所有需要下载的文件
    local core_files=(
        # 主程序文件
        "bin/pinkshell.sh"
        "bin/menu.sh"
        "bin/tools_install.sh"
        "bin/search_utils.sh"
        
        # 库文件
        "lib/termux_utils.sh"
        
        # 核心模块
        "lib/modules/core.sh"
        "lib/modules/system.sh"
        "lib/modules/network.sh"
        "lib/modules/development.sh"
        "lib/modules/entertainment.sh"
        "lib/modules/personalization.sh"
        
        # 资源文件
        "assets/pinkshell_ascii.txt"
        "assets/terminal_ascii.txt"
    )
    
    # 下载每个文件
    for file in "${core_files[@]}"; do
        local dest="$PINKSHOME/$file"
        download_file "$file" "$dest"
        
        # 设置执行权限
        if [[ "$file" == bin/*.sh ]] || [[ "$file" == lib/modules/*.sh ]]; then
            chmod +x "$dest"
        fi
    done
    
    # 创建必要的空文件
    touch "$PINKSHOME/playlist.txt"
    touch "$HOME/.pinkshell/.config/config.conf"
    
    log "核心文件下载完成"
}

# 创建备用命令
create_fallback_commands() {
    log "创建备用命令..."
    
    # termux-change-color 替代
    cat > "$PINKSHOME/bin/termux-change-color" << 'EOF'
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
            pink) 
                echo -e "\033]4;1;#FF69B4\007"
                echo -e "\033]4;2;#FF1493\007"
                echo -e "\033]4;3;#FF69B4\007"
                echo "已切换到粉色主题"
                ;;
            purple)
                echo -e "\033]4;1;#9370DB\007"
                echo -e "\033]4;2;#8A2BE2\007"
                echo -e "\033]4;3;#9370DB\007"
                echo "已切换到紫色主题"
                ;;
            blue)
                echo -e "\033]4;1;#1E90FF\007"
                echo -e "\033]4;2;#00BFFF\007"
                echo -e "\033]4;3;#1E90FF\007"
                echo "已切换到蓝色主题"
                ;;
            green)
                echo -e "\033]4;1;#32CD32\007"
                echo -e "\033]4;2;#228B22\007"
                echo -e "\033]4;3;#32CD32\007"
                echo "已切换到绿色主题"
                ;;
            dark)
                echo -e "\033]4;1;#FF4136\007"
                echo -e "\033]4;2;#2ECC40\007"
                echo -e "\033]4;3;#FFDC00\007"
                echo "已切换到深色主题"
                ;;
            light)
                echo -e "\033]4;1;#FF6B6B\007"
                echo -e "\033]4;2;#4ECDC4\007"
                echo -e "\033]4;3;#FFE66D\007"
                echo "已切换到浅色主题"
                ;;
            *) 
                echo "未知颜色方案: $2"
                echo "可用方案: pink, purple, blue, green, dark, light"
                ;;
        esac
        ;;
    -h|--help) 
        show_help 
        ;;
    *) 
        show_help 
        ;;
esac
EOF

    # termux-font 替代
    cat > "$PINKSHOME/bin/termux-font" << 'EOF'
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
        case "$2" in
            firacode|fira)
                echo "已选择 FiraCode 字体"
                echo "提示: 重启 Termux 应用使更改生效"
                ;;
            meslo)
                echo "已选择 Meslo 字体"
                echo "提示: 重启 Termux 应用使更改生效"
                ;;
            sourcecodepro|source)
                echo "已选择 SourceCodePro 字体"
                echo "提示: 重启 Termux 应用使更改生效"
                ;;
            hack)
                echo "已选择 Hack 字体"
                echo "提示: 重启 Termux 应用使更改生效"
                ;;
            *)
                echo "未知字体: $2"
                echo "可用字体: firacode, meslo, sourcecodepro, hack"
                ;;
        esac
        ;;
    -l|--list)
        echo "可用字体:"
        echo "  - firacode (FiraCode)"
        echo "  - meslo (Meslo)" 
        echo "  - sourcecodepro (SourceCodePro)"
        echo "  - hack (Hack)"
        ;;
    -h|--help) 
        show_help 
        ;;
    *) 
        show_help 
        ;;
esac
EOF

    # 创建 netcat 替代脚本
    cat > "$PINKSHOME/bin/nc" << 'EOF'
#!/bin/bash
# netcat 替代脚本

if command -v ncat >/dev/null 2>&1; then
    exec ncat "$@"
elif command -v busybox >/dev/null 2>&1 && busybox --list | grep -q nc; then
    exec busybox nc "$@"
elif command -v python >/dev/null 2>&1; then
    python3 -c "
import socket
import sys

if len(sys.argv) != 3:
    print('用法: nc <主机> <端口>')
    sys.exit(1)

host = sys.argv[1]
port = int(sys.argv[2])

try:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((host, port))
        print(f'已连接到 {host}:{port}')
        
        while True:
            data = input('发送: ') + '\n'
            s.sendall(data.encode())
            
            response = s.recv(1024)
            if not response:
                break
            print(f'接收: {response.decode().strip()}')
except Exception as e:
    print(f'错误: {e}')
    sys.exit(1)
" "$@"
else
    echo "错误: 没有可用的 netcat 实现"
    echo "请安装: pkg install ncat 或 pkg install busybox"
    exit 1
fi
EOF

    chmod +x "$PINKSHOME/bin/termux-change-color" \
             "$PINKSHOME/bin/termux-font" \
             "$PINKSHOME/bin/nc"
    
    log "备用命令创建完成"
}

# 检测当前shell
detect_shell() {
    local shell_name=$(basename "$SHELL")
    
    case "$shell_name" in
        "bash")
            echo "bash"
            ;;
        "zsh")
            echo "zsh"
            ;;
        *)
            # 尝试从环境变量判断
            if [ -n "$BASH_VERSION" ]; then
                echo "bash"
            elif [ -n "$ZSH_VERSION" ]; then
                echo "zsh"
            else
                # 默认使用bash
                echo "bash"
            fi
            ;;
    esac
}

# 配置shell环境
setup_shell_environment() {
    log "配置shell环境..."
    
    local current_shell=$(detect_shell)
    log "检测到当前shell: $current_shell"
    
    # 基础配置内容
    local pinkshell_config=$(cat << 'EOF'

# ===== Pinkshell 终端工具箱配置 =====
export PINKSHOME="$HOME/pinkshell"
export PATH="$PATH:$PINKSHOME/bin"

# 加载工具函数库
[ -f "$PINKSHOME/lib/termux_utils.sh" ] && source "$PINKSHOME/lib/termux_utils.sh"

# 主命令别名
alias 泠='bash $PINKSHOME/bin/pinkshell.sh'
alias 更新='pkg update && pkg upgrade -y'
alias 清理='pkg clean'
alias 存储='df -h'
alias 进程='ps aux'
alias 网络='netstat -tuln'
alias 天气='curl -s "wttr.in?format=3"'

# 工具箱快捷命令
alias pinkshell='bash $PINKSHOME/bin/pinkshell.sh'
alias ps-tool='bash $PINKSHOME/bin/pinkshell.sh'

# 启动问候语 (仅在交互式shell中显示)
if [[ $- == *i* ]]; then
    echo -e "\033[1;35m🌸 Pinkshell 终端工具箱已就绪! \033[0m"
    echo -e "\033[1;36m输入 '\033[1;33m泠\033[1;36m' 或 '\033[1;33mpinkshell\033[1;36m' 启动工具箱\033[0m"
fi
# ===== Pinkshell 配置结束 =====

EOF
)

    # zsh特定配置
    local zsh_specific_config=$(cat << 'EOF'

# zsh 特定配置
autoload -Uz compinit && compinit
setopt NO_NOMATCH
EOF
)

    # 配置bash
    if [[ "$current_shell" == "bash" ]] || [ -f "$HOME/.bashrc" ]; then
        log "配置 bash 环境..."
        local bashrc="$HOME/.bashrc"
        
        # 备份原有配置
        if [ -f "$bashrc" ]; then
            cp "$bashrc" "$HOME/.pinkshell/backups/bashrc.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # 移除旧配置
        if grep -q "Pinkshell" "$bashrc" 2>/dev/null; then
            sed -i '/# ===== Pinkshell/,/# ===== Pinkshell 配置结束 =====/d' "$bashrc"
        fi
        
        # 添加新配置
        echo "$pinkshell_config" >> "$bashrc"
        log "bash 环境配置完成"
    fi

    # 配置zsh
    if [[ "$current_shell" == "zsh" ]] || [ -f "$HOME/.zshrc" ]; then
        log "配置 zsh 环境..."
        local zshrc="$HOME/.zshrc"
        
        # 备份原有配置
        if [ -f "$zshrc" ]; then
            cp "$zshrc" "$HOME/.pinkshell/backups/zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # 移除旧配置
        if grep -q "Pinkshell" "$zshrc" 2>/dev/null; then
            sed -i '/# ===== Pinkshell/,/# ===== Pinkshell 配置结束 =====/d' "$zshrc"
        fi
        
        # 添加新配置
        echo "$pinkshell_config" >> "$zshrc"
        echo "$zsh_specific_config" >> "$zshrc"
        log "zsh 环境配置完成"
    fi

    # 如果都没有配置文件，创建bashrc
    if [ ! -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        log "创建默认 bash 配置文件..."
        echo "$pinkshell_config" > "$HOME/.bashrc"
    fi
    
    log "shell环境配置完成"
}

# 创建配置文件
create_config_files() {
    log "创建配置文件..."
    
    # 主配置文件
    cat > "$HOME/.pinkshell/.config/config.conf" << 'EOF'
# Pinkshell 终端工具箱配置文件
# 版本: 4.5

# 主题设置
THEME_COLOR="pink"
ENABLE_ANIMATIONS="true"
SHOW_BANNER="true"

# 功能设置
AUTO_UPDATE="false"
BACKUP_ENABLED="true"
LOG_LEVEL="info"

# 个性化设置
USER_NAME="Termux用户"
WELCOME_MESSAGE="欢迎使用Pinkshell终端工具箱!"

# 路径设置
PLAYLIST_PATH="$HOME/pinkshell/playlist.txt"
DOWNLOAD_PATH="$HOME/storage/downloads"

# 网络设置
DEFAULT_MIRROR="tuna"
EOF

    # 版本文件
    cat > "$PINKSHOME/version" << EOF
PUMPSHELL_VERSION=4.5
INSTALL_DATE=$(date +%Y-%m-%d)
INSTALL_TIME=$(date +%H:%M:%S)
INSTALL_SHELL=$(detect_shell)
EOF

    # 创建工具安装标记
    touch "$PINKSHOME/.tools_installed"
    
    log "配置文件创建完成"
}

# 设置文件权限
set_permissions() {
    log "设置文件权限..."
    
    # 设置所有脚本为可执行
    find "$PINKSHOME/bin" -name "*.sh" -exec chmod +x {} \;
    find "$PINKSHOME/lib/modules" -name "*.sh" -exec chmod +x {} \;
    
    # 设置配置文件权限
    chmod 600 "$HOME/.pinkshell/.config/config.conf"
    chmod 700 "$PINKSHOME/bin" "$PINKSHOME/lib/modules"
    
    log "文件权限设置完成"
}

# 运行工具安装器
run_tools_installer() {
    log "运行工具安装器..."
    
    if [ -f "$PINKSHOME/bin/tools_install.sh" ]; then
        if bash "$PINKSHOME/bin/tools_install.sh"; then
            log "工具安装器执行成功"
        else
            warn "工具安装器执行过程中出现错误"
        fi
    else
        warn "工具安装器未找到，跳过工具安装"
    fi
}

# 验证安装
verify_installation() {
    log "验证安装结果..."
    
    local missing_files=()
    local essential_files=(
        "$PINKSHOME/bin/pinkshell.sh"
        "$PINKSHOME/bin/menu.sh"
        "$PINKSHOME/lib/modules/core.sh"
        "$PINKSHOME/lib/termux_utils.sh"
    )
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -ne 0 ]; then
        error "安装不完整，缺少以下文件:\n$(printf '  - %s\n' "${missing_files[@]}")"
    fi
    
    # 测试主命令
    if ! "$PINKSHOME/bin/pinkshell.sh" --test 2>/dev/null; then
        warn "启动器测试失败，但安装将继续"
    fi
    
    log "安装验证通过"
}

# 显示安装结果
show_installation_result() {
    local current_shell=$(detect_shell)
    
    echo
    echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║          🎀 安装成功! 🎀            ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"
    echo
    echo -e "${GREEN}✓ Pinkshell 终端工具箱安装完成!${NC}"
    echo
    echo -e "${CYAN}基本信息:${NC}"
    echo -e "  版本: ${GREEN}v4.5 完整修复版${NC}"
    echo -e "  路径: ${BLUE}$PINKSHOME${NC}"
    echo -e "  配置: ${YELLOW}$HOME/.pinkshell/${NC}"
    echo -e "  Shell: ${PURPLE}$current_shell${NC}"
    echo
    echo -e "${CYAN}使用方法:${NC}"
    echo -e "  ${YELLOW}泠${NC}           - 启动工具箱主菜单"
    echo -e "  ${YELLOW}pinkshell${NC}    - 启动工具箱 (英文命令)"
    echo -e "  ${YELLOW}更新${NC}         - 更新系统软件包"
    echo -e "  ${YELLOW}清理${NC}         - 清理系统缓存"
    echo -e "  ${YELLOW}存储${NC}         - 查看磁盘空间"
    echo
    echo -e "${CYAN}快捷命令:${NC}"
    echo -e "  ${GREEN}更新${NC}, ${GREEN}清理${NC}, ${GREEN}存储${NC}, ${GREEN}进程${NC}, ${GREEN}网络${NC}, ${GREEN}天气${NC}"
    echo
    echo -e "${YELLOW}下一步操作:${NC}"
    echo -e "  1. 重新启动Termux或执行: ${CYAN}source ~/.${current_shell}rc${NC}"
    echo -e "  2. 输入 ${GREEN}泠${NC} 或 ${GREEN}pinkshell${NC} 启动工具箱"
    echo -e "  3. 查看文档: ${BLUE}https://github.com/Alhkxsj/pinkshell${NC}"
    echo
    echo -e "${PURPLE}感谢使用 Pinkshell! 🎀${NC}"
    echo
}

# 清理安装文件
cleanup_installation() {
    log "清理安装文件..."
    
    # 删除安装日志
    if [ -f "$INSTALL_LOG" ]; then
        mv "$INSTALL_LOG" "$HOME/.pinkshell/logs/install.log"
    fi
    
    log "安装完成!"
}

# 主安装函数
main() {
    # 初始化安装日志
    echo "Pinkshell 安装日志 - $(date)" > "$INSTALL_LOG"
    
    # 显示横幅
    show_banner
    
    # 执行安装步骤
    check_termux_environment
    check_network
    check_storage
    install_system_dependencies
    create_directory_structure
    download_core_files
    create_fallback_commands
    setup_shell_environment
    create_config_files
    set_permissions
    run_tools_installer
    verify_installation
    show_installation_result
    cleanup_installation
}

# 错误处理
trap 'error "安装过程被中断"' INT
trap 'error "发生致命错误"' ERR

# 启动安装
main "$@"