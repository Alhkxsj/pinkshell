#!/bin/bash
# Pinkshell 统一启动器 - 主入口点

# 严格的错误处理
set -euo pipefail

# 基础颜色定义（防止模块加载失败）
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# 全局路径定义
PINKSHOME="$HOME/pinkshell"
MODULES_DIR="$PINKSHOME/lib/modules"
CONFIG_DIR="$HOME/.pinkshell/.config"
LOG_DIR="$HOME/.pinkshell/logs"

# 显示紧急错误信息
show_emergency_error() {
    echo -e "${RED}╔══════════════════════════════════════╗${NC}"
    echo -e "${RED}║          紧急错误信息               ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}问题: $1${NC}"
    echo -e "${CYAN}建议解决方案: $2${NC}"
    echo
}

# 环境检查
check_environment() {
    # 检查是否在Termux环境中
    if [ -z "${PREFIX:-}" ] || [ ! -d "/data/data/com.termux" ]; then
        show_emergency_error "非Termux环境" "请在Termux应用中运行此工具箱"
        return 1
    fi
    
    # 检查pinkshell目录是否存在
    if [ ! -d "$PINKSHOME" ]; then
        show_emergency_error "Pinkshell未安装" "请运行: bash <(curl -fsSL https://raw.githubusercontent.com/Alhkxsj/pinkshell/main/install.sh)"
        return 1
    fi
    
    return 0
}

# 初始化必要目录
initialize_directories() {
    local dirs=("$CONFIG_DIR" "$LOG_DIR")
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
        fi
    done
    
    # 创建基础配置文件
    if [ ! -f "$CONFIG_DIR/config.conf" ]; then
        cat > "$CONFIG_DIR/config.conf" << 'EOF'
# Pinkshell 基础配置
THEME="pink"
LANGUAGE="zh_CN"
AUTO_UPDATE="false"
LOG_LEVEL="info"
EOF
    fi
}

# 安全检查
security_check() {
    local file="$1"
    
    # 检查文件是否存在
    if [ ! -f "$file" ]; then
        echo -e "${RED}错误: 文件不存在 - $file${NC}" >&2
        return 1
    fi
    
    # 检查文件权限
    if [ ! -r "$file" ]; then
        echo -e "${RED}错误: 文件不可读 - $file${NC}" >&2
        return 1
    fi
    
    # 检查文件大小（防止空文件）
    if [ ! -s "$file" ]; then
        echo -e "${YELLOW}警告: 文件为空 - $file${NC}" >&2
        return 1
    fi
    
    return 0
}

# 加载模块
load_module() {
    local module_name="$1"
    local module_path="$MODULES_DIR/$module_name"
    
    if security_check "$module_path"; then
        # 使用子shell加载模块，避免污染全局环境
        (
            source "$module_path"
        )
        return 0
    else
        echo -e "${RED}模块加载失败: $module_name${NC}" >&2
        return 1
    fi
}

# 显示启动信息
show_startup_info() {
    local version="4.5"
    if [ -f "$PINKSHOME/version" ]; then
        version=$(grep "PUMPSHELL_VERSION" "$PINKSHOME/version" | cut -d= -f2)
    fi
    
    echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        Pinkshell 终端工具箱          ║${NC}"
    echo -e "${GREEN}║            版本 $version              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
    echo -e "${CYAN}启动时间: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${BLUE}安装路径: $PINKSHOME${NC}"
    echo
}

# 依赖检查
check_dependencies() {
    local missing_deps=()
    local critical_deps=("bash" "curl")
    local optional_deps=("lolcat" "neofetch" "mpv" "nmap")
    
    # 检查关键依赖
    for dep in "${critical_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}警告: 缺少关键依赖 - ${missing_deps[*]}${NC}"
        echo -e "${CYAN}正在安装缺失依赖...${NC}"
        pkg update && pkg install -y "${missing_deps[@]}" || {
            echo -e "${RED}依赖安装失败，但将继续启动...${NC}"
        }
    fi
    
    # 检查可选依赖
    local missing_optional=()
    for dep in "${optional_deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing_optional+=("$dep")
        fi
    done
    
    if [ ${#missing_optional[@]} -gt 0 ]; then
        echo -e "${YELLOW}提示: 可选依赖未安装 - ${missing_optional[*]}${NC}"
        echo -e "${CYAN}如需完整功能，可运行: pkg install ${missing_optional[*]}${NC}"
    fi
}

# 主启动函数
main() {
    # 显示启动信息
    show_startup_info
    
    # 环境检查
    if ! check_environment; then
        exit 1
    fi
    
    # 初始化目录
    initialize_directories
    
    # 检查依赖
    check_dependencies
    
    # 加载核心模块
    if ! load_module "core.sh"; then
        echo -e "${RED}核心模块加载失败，无法启动${NC}"
        exit 1
    fi
    
    # 记录启动日志
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Pinkshell 启动" >> "$LOG_DIR/startup.log"
    
    # 启动主菜单
    echo -e "${GREEN}正在启动主菜单...${NC}"
    echo
    
    if [ -f "$PINKSHOME/bin/menu.sh" ]; then
        if security_check "$PINKSHOME/bin/menu.sh"; then
            exec bash "$PINKSHOME/bin/menu.sh"
        else
            echo -e "${RED}主菜单文件安全检查失败${NC}"
            exit 1
        fi
    else
        echo -e "${RED}错误: 找不到主菜单文件${NC}"
        exit 1
    fi
}

# 信号处理
trap 'echo -e "${YELLOW}程序被用户中断${NC}"; exit 130' INT
trap 'echo -e "${RED}程序异常退出${NC}"; exit 1' TERM

# 启动程序
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi