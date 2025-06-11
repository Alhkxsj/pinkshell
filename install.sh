#!/bin/bash
# 少女终端工具箱安装脚本
# 项目地址: https://github.com/Alhkxsj/pinkshell

# 颜色定义
PINK='\033[1;35m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'
NC='\033[0m'

echo -e "${PINK}"
echo "   ██████╗ ██╗   ██╗ ██████╗ ██╗  ██╗"
echo "  ██╔════╝ ██║   ██║██╔═══██╗██║  ██║"
echo "  ██║  ███╗██║   ██║██║   ██║███████║"
echo "  ██║   ██║██║   ██║██║   ██║██╔══██║"
echo "  ╚██████╔╝╚██████╔╝╚██████╔╝██║  ██║"
echo "   ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${PINK}[少女终端] 安装程序启动...${NC}"

# 检查依赖项
echo -e "${YELLOW}检查必要依赖...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}安装 curl...${NC}"
    pkg update -y && pkg install -y curl
fi

# 创建目录结构
echo -e "${YELLOW}创建目录结构...${NC}"
mkdir -p ~/pinkshell/{bin,lib}

# 下载必要文件
echo -e "${YELLOW}下载主程序文件...${NC}"
base_url="https://raw.githubusercontent.com/Alhkxsj/pinkshell/main"

download_file() {
    local path=$1
    local dest=$2
    echo -e "${BLUE}下载: $path${NC}"
    curl -fsSL -o "$dest" "${base_url}${path}" || {
        echo -e "${YELLOW}下载失败: $path, 尝试备用源...${NC}"
        curl -fsSL -o "$dest" "https://cdn.jsdelivr.net/gh/Alhkxsj/pinkshell${path}"
    }
}

# 下载核心文件
download_file "/bin/menu.sh" ~/pinkshell/bin/menu.sh
download_file "/bin/tools_install.sh" ~/pinkshell/bin/tools_install.sh
download_file "/lib/termux_utils.sh" ~/pinkshell/lib/termux_utils.sh

# 设置权限
chmod +x ~/pinkshell/bin/*.sh
chmod +x ~/pinkshell/lib/*.sh

# 修复 menu.sh 中的路径问题（关键修复）
echo -e "${YELLOW}修复脚本路径问题...${NC}"
sed -i 's|source ~/pinkshell/lib/termux_utils.sh|source $HOME/pinkshell/lib/termux_utils.sh|' ~/pinkshell/bin/menu.sh
sed -i 's|~/pinkshell/tools_installed|$HOME/pinkshell/tools_installed|g' ~/pinkshell/bin/menu.sh
sed -i 's|~/pinkshell/bin/menu.sh|$HOME/pinkshell/bin/menu.sh|g' ~/pinkshell/bin/menu.sh
sed -i 's|~/.pinkshell|$HOME/.pinkshell|g' ~/pinkshell/bin/menu.sh
sed -i 's|~/pinkshell|$HOME/pinkshell|g' ~/pinkshell/bin/tools_install.sh

# 添加环境变量
echo -e "${YELLOW}更新环境变量...${NC}"
grep -q "pinkshell/bin" ~/.bashrc || echo 'export PATH="$PATH:$HOME/pinkshell/bin"' >> ~/.bashrc
grep -q "termux_utils.sh" ~/.bashrc || echo 'source $HOME/pinkshell/lib/termux_utils.sh' >> ~/.bashrc

# 设置别名
echo -e "${YELLOW}创建快捷命令...${NC}"
grep -q "alias 泠" ~/.bashrc || echo "alias 泠='bash \$HOME/pinkshell/bin/menu.sh'" >> ~/.bashrc
grep -q "alias 更新" ~/.bashrc || echo "alias 更新='pkg update && pkg upgrade'" >> ~/.bashrc
grep -q "alias 清理" ~/.bashrc || echo "alias 清理='pkg clean'" >> ~/.bashrc
grep -q "alias 存储" ~/.bashrc || echo "alias 存储='df -h'" >> ~/.bashrc

# 显示完成信息
echo -e "${GREEN}"
echo "██████╗ ██╗   ██╗███████╗"
echo " ██╔═══██╗██║   ██║██╔════╝"
echo " ██║   ██║██║   ██║█████╗  "
echo " ██║▄▄ ██║██║   ██║██╔══╝  "
echo " ╚██████╔╝╚██████╔╝███████╗"
echo "  ╚══▀▀═╝  ╚═════╝ ╚══════╝"
echo -e "${NC}"

echo -e "${PINK}[安装完成] 专属工具箱已配置完毕！${NC}"
echo -e "${BLUE}使用以下命令启动:"
echo -e "  输入 '泠' 即可启动菜单${NC}"

# 首次运行工具安装器
echo -e "${YELLOW}首次使用需要安装必要工具，请稍候...${NC}"
bash ~/pinkshell/bin/tools_install.sh

# 应用环境变量
source ~/.bashrc 2>/dev/null

echo -e "${GREEN}安装完成！请重启Termux或执行: source ~/.bashrc${NC}"
