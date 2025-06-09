#!/data/data/com.termux/files/usr/bin/bash
# 🧩 全领域常用工具一键安装器（pinkshell专属）

echo -e "\033[1;35m
   ██████╗ ██╗   ██╗ ██████╗ ██╗  ██╗
  ██╔════╝ ██║   ██║██╔═══██╗██║  ██║
  ██║  ███╗██║   ██║██║   ██║███████║
  ██║   ██║██║   ██║██║   ██║██╔══██║
  ╚██████╔╝╚██████╔╝╚██████╔╝██║  ██║
   ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
\033[0m"
echo -e "\033[1;35m[少女终端] 正在准备工具列表...\033[0m"

# 定义工具领域及工具包
declare -A TOOL_SETS
TOOL_SETS["开发工具"]="git clang python nodejs"
TOOL_SETS["网络工具"]="curl wget nmap netcat"
TOOL_SETS["图形支持"]="x11-repo termux-x11"
TOOL_SETS["影音多媒体"]="ffmpeg mpv"
TOOL_SETS["实用工具"]="htop neofetch jq unzip zip tar"
TOOL_SETS["系统增强"]="proot-distro tsu termux-api"

# 统计变量
total_tools=0
installed_tools=0
skipped_tools=0

# 计算总工具数
for category in "${!TOOL_SETS[@]}"; do
  for pkg in ${TOOL_SETS[$category]}; do
    ((total_tools++))
  done
done

# 遍历安装
current_tool=0
for category in "${!TOOL_SETS[@]}"; do
  echo -e "\n\033[1;36m[安装中] $category...\033[0m"
  for pkg in ${TOOL_SETS[$category]}; do
    ((current_tool++))
    
    # 进度显示
    progress=$((current_tool * 100 / total_tools))
    echo -e "\033[1;33m[$progress%] 工具 $current_tool/$total_tools\033[0m"
    
    if ! command -v "$pkg" >/dev/null 2>&1; then
      echo -e " → 安装 \033[1;34m$pkg\033[0m..."
      if pkg install -y "$pkg" >/dev/null 2>&1; then
        echo -e "   \033[1;32m✓ 安装成功\033[0m"
        ((installed_tools++))
      else
        echo -e "   \033[1;31m✗ 安装失败\033[0m"
      fi
    else
      echo -e "   \033[1;35m✓ 已安装 \033[0m$pkg"
      ((skipped_tools++))
    fi
  done
done

# 安装结果统计
echo -e "\n\033[1;35m[安装报告]\033[0m"
echo -e "  \033[1;36m总工具数: \033[1;37m$total_tools\033[0m"
echo -e "  \033[1;32m成功安装: \033[1;37m$installed_tools\033[0m"
echo -e "  \033[1;35m已安装跳过: \033[1;37m$skipped_tools\033[0m"
echo -e "  \033[1;33m失败: \033[1;37m$((total_tools - installed_tools - skipped_tools))\033[0m"

# 最终完成提示
echo -e "\n\033[1;32m█████████████████████████████████"
echo -e "█                                     █"
echo -e "█   🎀 所有工具安装完毕！请尽情使用  🎀  █"
echo -e "█                                     █"
echo -e "█████████████████████████████████\033[0m"