#!/data/data/com.termux/files/usr/bin/bash
# 工具安装器
echo -e "\033[1;35m
   ██████╗ ██╗   ██╗ ██████╗ ██╗  ██╗
  ██╔════╝ ██║   ██║██╔═══██╗██║  ██║
  ██║  ███╗██║   ██║██║   ██║███████║
  ██║   ██║██║   ██║██║   ██║██╔══██║
  ╚██████╔╝╚██████╔╝╚██████╔╝██║  ██║
   ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
\033[0m"
echo -e "\033[1;35m[少女终端] 正在准备工具列表...\033[0m"

# 检查是否已安装过
if [ -f $HOME/pinkshell/tools_installed ]; then
  echo -e "\033[1;35m[少女终端] 工具已完整安装，跳过本次安装\033[0m"
  echo -e "\033[1;36m如需重新安装，请删除标记文件: rm $HOME/pinkshell/tools_installed\033[0m"
  exit 0
fi

# 定义工具领域及工具包
declare -A TOOL_SETS
TOOL_SETS["基础依赖"]="termux-exec"
TOOL_SETS["开发工具"]="git clang python nodejs"
TOOL_SETS["网络工具"]="curl wget nmap traceroute"
TOOL_SETS["图形支持"]="x11-repo termux-x11"
TOOL_SETS["影音多媒体"]="ffmpeg mpv"
TOOL_SETS["实用工具"]="htop neofetch jq unzip zip tar tree"
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

# 更可靠的检查函数
is_installed() {
  # 检查二进制路径
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  fi

  # 检查包管理器状态
  if pkg show "$1" 2>/dev/null | grep -q "installed: yes"; then
    return 0
  fi

  # 检查文件是否存在
  if [ -f "/data/data/com.termux/files/usr/bin/$1" ]; then
    return 0
  fi

  return 1
}

# 遍历安装
current_tool=0
categories=("基础依赖" "开发工具" "网络工具" "图形支持" "影音多媒体" "实用工具" "系统增强")

for category in "${categories[@]}"; do
  echo -e "\n\033[1;36m[安装中] $category...\033[0m"
  for pkg in ${TOOL_SETS[$category]}; do
    ((current_tool++))

    # 进度显示
    progress=$((current_tool * 100 / total_tools))
    echo -e "\033[1;33m[$progress%] 工具 $current_tool/$total_tools\033[0m"

    if ! is_installed "$pkg"; then
      echo -e " → 安装 \033[1;34m$pkg\033[0m..."
      
      # 静默安装，只显示必要信息
      if pkg install -y "$pkg" >/dev/null 2>&1; then
        echo -e "   \033[1;32m✓ 安装成功\033[0m"
        ((installed_tools++))
      else
        echo -e "   \033[1;31m✗ 安装失败\033[0m"
        
        # 特殊处理：nmap 安装失败时尝试替代方案
        if [ "$pkg" == "nmap" ]; then
          echo -e "   \033[1;33m尝试安装替代方案: ncat...\033[0m"
          if pkg install -y ncat >/dev/null 2>&1; then
            echo -e "   \033[1;32m✓ ncat 安装成功 (可作为 netcat 替代)\033[0m"
            ((installed_tools++))
          else
            echo -e "   \033[1;31m✗ ncat 安装也失败\033[0m"
          fi
        fi
      fi
    else
      echo -e "   \033[1;35m✓ 已安装 \033[0m$pkg"
      ((skipped_tools++))
    fi
  done
done

# 安装 netcat 替代方案（如果 nmap 和 ncat 都安装失败）
if ! command -v nc &> /dev/null && ! command -v ncat &> /dev/null; then
  echo -e "\n\033[1;33m[警告] netcat 未安装，尝试替代方案...\033[0m"
  
  # 选项1：安装 busybox 的 netcat 实现
  echo -e " → 尝试安装 \033[1;34mbusybox\033[0m (包含 netcat 功能)..."
  if pkg install -y busybox >/dev/null 2>&1; then
    echo -e "   \033[1;32m✓ busybox 安装成功\033[0m"
    echo -e "   \033[1;36m使用命令: busybox nc\033[0m"
    ((installed_tools++))
  else
    echo -e "   \033[1;31m✗ busybox 安装失败\033[0m"
  fi
  
  # 选项2：创建 Python 替代脚本
  if command -v python &> /dev/null; then
    echo -e " → 创建 \033[1;34mPython netcat 替代脚本\033[0m..."
    cat > $HOME/pinkshell/bin/nc << 'EOF'
#!/data/data/com.termux/files/usr/bin/python3
import socket
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description='简易 Python netcat 替代工具')
    parser.add_argument('host', help='目标主机')
    parser.add_argument('port', type=int, help='目标端口')
    args = parser.parse_args()
    
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((args.host, args.port))
            print(f"已连接到 {args.host}:{args.port}")
            
            while True:
                data = input("发送: ") + "\n"
                s.sendall(data.encode())
                
                response = s.recv(1024)
                if not response:
                    break
                print(f"接收: {response.decode().strip()}")
    except Exception as e:
        print(f"错误: {str(e)}")

if __name__ == "__main__":
    main()
EOF
    chmod +x $HOME/pinkshell/bin/nc
    echo -e "   \033[1;32m✓ Python netcat 替代脚本已创建\033[0m"
    echo -e "   \033[1;36m使用命令: nc <主机> <端口>\033[0m"
    ((installed_tools++))
  fi
fi

# 安装结果统计
echo -e "\n\033[1;35m[安装报告]\033[0m"
echo -e "  \033[1;36m总工具数: \033[1;37m$total_tools\033[0m"
echo -e "  \033[1;32m本次安装: \033[1;37m$installed_tools\033[0m"
echo -e "  \033[1;35m已存在跳过: \033[1;37m$skipped_tools\033[0m"
echo -e "  \033[1;33m失败: \033[1;37m$((total_tools - installed_tools - skipped_tools))\033[0m"

# 最终完成提示
echo -e "\n\033[1;32m█████████████████████████████████"
echo -e "█                                     █"
echo -e "█   🎀 所有工具安装完毕！请尽情使用  🎀  █"
echo -e "█                                     █"
echo -e "█████████████████████████████████\033[0m"

# 创建安装标记文件
mkdir -p $HOME/pinkshell
touch $HOME/pinkshell/tools_installed
echo -e "\033[1;35m[少女终端] 已创建安装标记文件，下次启动将跳过安装\033[0m"

# 显示 netcat 替代方案使用说明
if ! command -v nc &> /dev/null; then
  echo -e "\n\033[1;33m[重要] netcat 替代方案说明:\033[0m"
  
  if command -v ncat &> /dev/null; then
    echo -e "   \033[1;36m使用 ncat 替代 netcat: ncat <主机> <端口>\033[0m"
  elif command -v busybox &> /dev/null; then
    echo -e "   \033[1;36m使用 busybox 的 netcat: busybox nc <主机> <端口>\033[0m"
  elif [ -f "$HOME/pinkshell/bin/nc" ]; then
    echo -e "   \033[1;36m使用 Python netcat 替代: nc <主机> <端口>\033[0m"
    echo -e "   \033[1;36m提示: 此脚本需要 Python 支持\033[0m"
  else
    echo -e "   \033[1;31m警告: 没有可用的 netcat 替代方案\033[0m"
  fi
fi
