#!/data/data/com.termux/files/usr/bin/bash
# [Pinkshell]专属Termux工具箱 v4.5

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
NC='\033[0m'

# 检查依赖
check_dependencies() {
  # 检查工具安装标记
  if [ -f $HOME/pinkshell/tools_installed ]; then
    return
  fi

  # 检查lolcat
  if ! command -v lolcat &>/dev/null; then
    echo -e "${YELLOW}正在安装lolcat...${NC}"
    pkg update -y && pkg install -y ruby
    gem install lolcat
  fi

  # 检查其他可能需要的工具
  for tool in curl wget neofetch mpv aria2 nmap; do
    if ! command -v $tool &>/dev/null; then
      echo -e "${YELLOW}正在安装 $tool...${NC}"
      pkg install -y $tool
    fi
  done

  # 运行工具安装器
  echo -e "${PURPLE}[少女终端] 正在运行工具安装器...${NC}"
  if [ -f $HOME/pinkshell/bin/tools_install.sh ]; then
    bash $HOME/pinkshell/bin/tools_install.sh
  else
    echo -e "${RED}错误: 找不到工具安装器 ($HOME/pinkshell/bin/tools_install.sh)${NC}"
    echo -e "${YELLOW}请重新安装pinkshell${NC}"
    sleep 3
  fi
}

# 动态标题
welcome_banner() {
  clear
  # 兼容模式：当lolcat不可用时使用普通颜色
  if command -v lolcat &>/dev/null; then
    echo -e "${PURPLE}
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
    ${NC}" | lolcat -p 0.6
  else
    echo -e "${PURPLE}
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
    ${NC}"
  fi

  if command -v lolcat &>/dev/null; then
    echo "◆ 作者：快手啊泠好困想睡觉 ◆" | lolcat
    echo "► 日期：$(date +'%Y-%m-%d %H:%M') ◄" | lolcat
  else
    echo -e "${CYAN}◆ 作者：${YELLOW}快手啊泠好困想睡觉 ${CYAN}◆${NC}"
    echo -e "${GREEN}► 日期：$(date +'%Y-%m-%d %H:%M') ◄${NC}"
  fi
  echo
}

# 彩蛋功能
show_easter_egg() {
  clear
  welcome_banner
  
  # 彩蛋标题动画
  echo -e "${PURPLE}╔══════════════════════════════════════╗${NC}"
  echo -e "${PINK}║           🌸 Pinkshell 彩蛋 🌸         ║${NC}"
  echo -e "${PURPLE}╚══════════════════════════════════════╝${NC}"
  echo ""
  
  # 星星闪烁动画
  for i in {1..3}; do
    echo -en "${YELLOW}✨ ${CYAN}🌟 ${GREEN}✨ ${BLUE}🌟 ${NC}"
    sleep 0.3
    echo -en "\r${CYAN}🌟 ${GREEN}✨ ${BLUE}🌟 ${YELLOW}✨ ${NC}"
    sleep 0.3
    echo -en "\r${GREEN}✨ ${BLUE}🌟 ${YELLOW}✨ ${CYAN}🌟 ${NC}"
    sleep 0.3
    echo -en "\r${BLUE}🌟 ${YELLOW}✨ ${CYAN}🌟 ${GREEN}✨ ${NC}"
    sleep 0.3
  done
  echo -e "\n"
  
  # 彩蛋内容
  echo -e "${PINK}══════════════════════════════════════${NC}"
  echo -e "${CYAN}🎉 欢迎使用 Pinkshell 终端工具箱！${NC}"
  echo -e "${YELLOW}作者: 快手啊泠好困想睡觉${NC}"
  echo -e "${GREEN}版本: v4.5${NC}"
  echo -e "${PINK}══════════════════════════════════════${NC}"
  
  # 系统信息
  echo -e "\n${BLUE}🖥️  系统信息:${NC}"
  if command -v neofetch &>/dev/null; then
    neofetch --stdout | head -n 10 | lolcat
  else
    echo -e "${CYAN}设备: $(uname -npo)${NC}"
    echo -e "${PURPLE}内核: $(uname -r)${NC}"
    echo -e "${YELLOW}存储: $(df -h / | awk 'NR==2 {print $4}') 可用${NC}"
    echo -e "${GREEN}内存: $(free -h | awk 'NR==2 {print $7}') 可用${NC}"
  fi
  
  # 彩蛋小游戏
  echo -e "\n${PINK}🎮 彩蛋小游戏${NC}"
  echo -e "${YELLOW}猜猜我现在在想什么？${NC}"
  echo -e "${CYAN}提示: 是一个数字 (1-10)${NC}"
  
  # 生成随机数
  secret_number=$((RANDOM % 10 + 1))
  attempts=0
  max_attempts=3
  
  while [ $attempts -lt $max_attempts ]; do
    read -p "$(echo -e "${GREEN}请输入你的猜测 (剩余 $((max_attempts - attempts)) 次机会): ${NC}")" guess
    
    # 检查输入是否为数字
    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
      echo -e "${RED}请输入有效数字！${NC}"
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
  
  # 随机名言和祝福
  quotes=(
    "代码如诗，逻辑如画，编程是艺术与科学的完美结合。"
    "在0和1的世界里，你是唯一的变量。"
    "每个bug都是成长的机会，每个错误都是进步的阶梯。"
    "编程不是工作，而是创造世界的魔法。"
    "一行代码，一份热爱；一个算法，一份执着。"
    "代码改变世界，程序创造未来。"
    "程序是写给人读的，只是顺便能在机器上运行。"
    "编程是一种思想，而不是一种语言。"
  )
  
  blessings=(
    "愿你的代码永远没有bug！"
    "愿你的程序运行流畅如飞！"
    "愿你的创意无限迸发！"
    "愿你的技术日益精进！"
    "愿你享受编程的每一刻！"
    "愿你成为代码世界的魔法师！"
  )
  
  random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
  random_blessing=${blessings[$RANDOM % ${#blessings[@]}]}
  
  echo -e "\n${PURPLE}「 ${random_quote} 」${NC}" | lolcat
  echo -e "\n${PINK}💝 ${random_blessing} ${NC}" | lolcat
  
  # 彩虹动画结束
  echo -e "\n${RED}❤${YELLOW}❤${GREEN}❤${CYAN}❤${BLUE}❤${PURPLE}❤${PINK}❤${NC}"
  echo -e "${CYAN}感谢使用 Pinkshell！${NC}"
  echo -e "${GREEN}按任意键返回主菜单...${NC}"
  read -n 1 -s
}

# 进程管理
process_manager() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 进程管理 ==========${NC}"
    echo -e "1. 查看所有进程"
    echo -e "2. 查找进程"
    echo -e "3. 结束进程"
    echo -e "0. 返回\n"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${GREEN}所有进程:${NC}"
        ps -ef | lolcat
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        read -p "请输入进程名: " process_name
        if [ -z "$process_name" ]; then
          echo -e "${RED}进程名不能为空！${NC}"
          sleep 1
          continue
        fi
        echo -e "${GREEN}查找结果:${NC}"
        ps -ef | grep "$process_name" | grep -v grep | lolcat
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        read -p "请输入进程PID: " pid
        if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
          echo -e "${RED}无效的PID！${NC}"
          sleep 1
          continue
        fi
        kill -9 $pid
        echo -e "${GREEN}已结束进程 $pid${NC}"
        sleep 1
        ;;
      0)
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 磁盘分析
disk_analysis() {
  echo -e "${CYAN}文件系统使用情况:${NC}"
  df -h | awk 'NR==1{print $0}NR>1{print $0 | "sort -k5 -rn"}' | head -n 6 | lolcat
  echo -e "\n${CYAN}目录大小排行:${NC}"
  du -h -d 1 $HOME/ 2>/dev/null | sort -hr | head -n 10 | lolcat
  echo -e "\n${CYAN}按任意键返回...${NC}"
  read -n 1 -s
}

# 系统工具菜单
system_tools() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 系统工具 ==========${NC}"
    echo -e "1. 系统信息"
    echo -e "2. 存储空间分析"
    echo -e "3. 进程管理"
    echo -e "4. 系统更新"
    echo -e "5. 磁盘使用详情"
    echo -e "6. 更换软件源"
    echo -e "0. 返回主菜单\n"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        if command -v neofetch &>/dev/null; then
          neofetch | lolcat
        else
          echo -e "${YELLOW}正在安装neofetch...${NC}"
          pkg install neofetch -y
          neofetch | lolcat
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        echo -e "${GREEN}存储空间分析:${NC}"
        echo -e "${CYAN}文件系统使用情况:${NC}"
        df -h | awk 'NR==1{print $0}NR>1{print $0 | "sort -k5 -rn"}' | head -n 6 | lolcat
        echo -e "\n${CYAN}目录大小排行:${NC}"
        du -h -d 1 $HOME/ 2>/dev/null | sort -hr | head -n 10 | lolcat
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        process_manager
        ;;
      4)
        echo -e "${CYAN}正在更新系统...${NC}"
        pkg update -y && pkg upgrade -y
        echo -e "\n${GREEN}更新完成，按任意键返回...${NC}"
        read -n 1 -s
        ;;
      5)
        echo -e "${GREEN}磁盘使用详情:${NC}"
        disk_analysis
        ;;
      6)
        change_termux_source
        ;;
      0)
        main_menu
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 更换软件源
change_termux_source() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 更换软件源 ==========${NC}"
    echo -e "${YELLOW}当前软件源:${NC}"
    grep -o '@[^/]*' $PREFIX/etc/apt/sources.list | sed 's/^@//' || echo "默认源"
    
    echo -e "\n${GREEN}请选择软件源:${NC}"
    echo -e "1. 清华大学源 (推荐)"
    echo -e "2. 阿里云源"
    echo -e "3. 南京大学源"
    echo -e "4. 官方源"
    echo -e "5. 自定义源"
    echo -e "0. 返回上一级\n"
    echo -e "${BLUE}================================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${CYAN}正在更换为清华大学源...${NC}"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为清华大学源！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        echo -e "${CYAN}正在更换为阿里云源...${NC}"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.aliyun.com/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为阿里云源！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        echo -e "${CYAN}正在更换为南京大学源...${NC}"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirror.nju.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为南京大学源！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      4)
        echo -e "${CYAN}正在更换为官方源...${NC}"
        sed -i 's@^#deb\(.*\)@deb\1@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为官方源！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      5)
        read -p "请输入自定义源地址: " custom_source
        if [ -z "$custom_source" ]; then
          echo -e "${RED}源地址不能为空！${NC}"
          sleep 1
          continue
        fi
        echo -e "${CYAN}正在更换为自定义源...${NC}"
        sed -i "s@^\(deb.*stable main\)\$@#\1\ndeb $custom_source stable main@" $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为自定义源！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      0)
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 网络工具菜单
network_tools() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 网络工具 ==========${NC}"
    echo -e "1. IP信息"
    echo -e "2. 网络测速"
    echo -e "3. 端口扫描"
    echo -e "4. 下载工具"
    echo -e "5. 网络诊断"
    echo -e "0. 返回主菜单
"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${GREEN}IP地址信息:${NC}"
        if command -v curl &>/dev/null; then
          curl ipinfo.io | lolcat
        else
          ip addr show | grep inet | grep -v inet6 | lolcat
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        echo -e "${YELLOW}正在测试网络速度...${NC}"
        # 使用Termux支持的替代测速方法
        if command -v iperf3 &>/dev/null; then
          echo -e "${CYAN}使用iperf3测试网络速度...${NC}"
          echo -e "${YELLOW}正在连接测试服务器...${NC}"
          iperf3 -c speedtest.serverius.net -p 5002 -P 4 | lolcat
        elif command -v curl &>/dev/null; then
          echo -e "${CYAN}使用文件下载速度测试...${NC}"
          echo -e "${YELLOW}测试下载速度（通过Google）...${NC}"
          start_time=$(date +%s)
          download_size=$(curl -s -w '%{size_download}' -o /dev/null https://www.google.com)
          end_time=$(date +%s)
          time_elapsed=$((end_time - start_time))
          if [ $time_elapsed -eq 0 ]; then
              time_elapsed=1
          fi
          speed=$((download_size * 8 / time_elapsed / 1000))
          echo -e "${GREEN}下载速度: ${speed} kbps${NC}" | lolcat
        else
          echo -e "${RED}无法进行网络测速，请先安装curl${NC}"
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        read -p "请输入要扫描的IP或域名: " target
        if [ -z "$target" ]; then
          target="127.0.0.1"
        fi

        # 优先使用 nmap
        if command -v nmap &>/dev/null; then
          echo -e "${YELLOW}正在使用 nmap 扫描 $target ...${NC}"
          nmap -T4 $target | lolcat
        
        # 其次使用 ncat (nmap 的一部分)
        elif command -v ncat &>/dev/null; then
          echo -e "${YELLOW}正在使用 ncat 进行快速端口扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            timeout 1 ncat -zv $target $port 2>&1 | grep succeeded | lolcat
          done
        
        # 使用 Python 替代方案
        elif [ -f "$HOME/pinkshell/bin/nc" ]; then
          echo -e "${YELLOW}正在使用 Python 端口扫描器扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            echo "扫描端口 $port ..."
            $HOME/pinkshell/bin/nc $target $port <<< "QUIT" 2>/dev/null && echo "端口 $port 开放" | lolcat
          done
        
        # 最后尝试 busybox
        elif command -v busybox &>/dev/null; then
          echo -e "${YELLOW}正在使用 busybox 扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            timeout 1 busybox nc -zv $target $port 2>&1 | grep succeeded | lolcat
          done
        
        else
          echo -e "${RED}未找到端口扫描工具，请安装 nmap${NC}"
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      4)
        read -p "请输入下载链接: " url
        if [ -z "$url" ]; then
          echo -e "${RED}下载链接不能为空！${NC}"
          sleep 1
          continue
        fi

        # 优先使用 aria2
        if command -v aria2c &>/dev/null; then
          echo -e "${YELLOW}正在使用aria2下载...${NC}"
          aria2c -x 16 $url
        
        # 其次使用 curl
        elif command -v curl &>/dev/null; then
          echo -e "${YELLOW}正在使用curl下载...${NC}"
          filename=$(basename "$url")
          curl -O $url
          echo -e "${GREEN}文件已下载: $filename${NC}"
        
        # 使用 wget
        elif command -v wget &>/dev/null; then
          echo -e "${YELLOW}正在使用wget下载...${NC}"
          wget $url
        
        else
          echo -e "${RED}未找到下载工具，请安装 aria2、curl 或 wget${NC}"
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      5)
        echo -e "${GREEN}网络诊断信息:${NC}"
        echo -e "${CYAN}网络连接状态:${NC}"
        echo -e "${YELLOW}正在测试与Google的连接...${NC}"
        
        # 优先使用 ncat
        if command -v ncat &>/dev/null; then
          ncat -zv google.com 80 2>&1 | lolcat
        # 其次使用 Python 替代方案
        elif [ -f "$HOME/pinkshell/bin/nc" ]; then
          $HOME/pinkshell/bin/nc google.com 80 <<< "HEAD / HTTP/1.1\nHost: google.com\n\n" | lolcat
        # 使用 busybox
        elif command -v busybox &>/dev/null; then
          busybox nc -zv google.com 80 2>&1 | lolcat
        else
          ping -c 4 google.com | lolcat
        fi
        
        echo -e "\n${CYAN}路由追踪:${NC}"
        if command -v traceroute &>/dev/null; then
          traceroute google.com | lolcat
        else
          echo -e "${YELLOW}正在安装traceroute...${NC}"
          pkg install traceroute -y
          if command -v traceroute &>/dev/null; then
            traceroute google.com | lolcat
          else
            echo -e "${RED}安装失败！请手动安装: pkg install traceroute${NC}"
          fi
        fi
        
        echo -e "\n${CYAN}DNS解析:${NC}"
        echo -e "${YELLOW}正在测试DNS解析...${NC}"
        nslookup google.com | lolcat
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      0)
        main_menu
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 开发工具菜单
dev_tools() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 开发工具 ==========${NC}"
    echo -e "1. Python环境"
    echo -e "2. Node.js环境"
    echo -e "3. Git工具"
    echo -e "4. 代码编辑器"
    echo -e "5. 开发环境配置"
    echo -e "0. 返回主菜单\n"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        if command -v python &>/dev/null; then
          echo -e "${GREEN}Python已安装:${NC}"
          python --version | lolcat
          echo -e "\n${CYAN}Python包列表:${NC}"
          pip list | lolcat
        else
          echo -e "${YELLOW}正在安装Python...${NC}"
          pkg install python -y
          python --version | lolcat
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        if command -v node &>/dev/null; then
          echo -e "${GREEN}Node.js已安装:${NC}"
          node --version | lolcat
          echo -e "\n${CYAN}npm全局包列表:${NC}"
          npm list -g --depth=0 | lolcat
        else
          echo -e "${YELLOW}正在安装Node.js...${NC}"
          pkg install nodejs -y
          node --version | lolcat
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        if command -v git &>/dev/null; then
          echo -e "${GREEN}Git已安装:${NC}"
          git --version | lolcat
          echo -e "\n${CYAN}Git配置:${NC}"
          git config --list | lolcat
        else
          echo -e "${YELLOW}正在安装Git...${NC}"
          pkg install git -y
          git --version | lolcat
        fi
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      4)
        echo -e "${GREEN}请选择代码编辑器:${NC}"
        echo -e "1. Nano (简单易用)"
        echo -e "2. Vim (功能强大)"
        echo -e "3. Micro (现代终端编辑器)"
        read -p "请选择: " editor_choice

        case $editor_choice in
          1)
            if command -v nano &>/dev/null; then
              nano
            else
              pkg install nano -y
              nano
            fi
            ;;
          2)
            if command -v vim &>/dev/null; then
              vim
            else
              pkg install vim -y
              vim
            fi
            ;;
          3)
            if command -v micro &>/dev/null; then
              micro
            else
              echo -e "${CYAN}正在安装Micro编辑器...${NC}"
              pkg install micro -y
              micro
            fi
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        ;;
      5)
        echo -e "${YELLOW}正在配置开发环境...${NC}"
        # 安装常用开发工具
        pkg install clang make cmake -y
        # 安装Python开发环境
        pkg install python-numpy python-pip -y
        # 安装Node.js开发环境
        pkg install nodejs -y
        npm install -g npm@latest
        echo -e "${GREEN}开发环境配置完成！${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      0)
        main_menu
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# ================== 娱乐功能 (增强版) ================== #
# 获取循环模式名称
get_loop_mode_name() {
  case $1 in
    0) echo "顺序播放" ;;
    1) echo "单曲循环" ;;
    2) echo "列表循环" ;;
    *) echo "未知模式" ;;
  esac
}

# 播放单个音乐文件
play_music() {
  local music="$1"
  if command -v mpv &>/dev/null; then
    echo -e "${YELLOW}正在播放...${NC}"
    echo -e "${CYAN}按 'p' 暂停/继续"
    echo -e "按 's' 停止播放${NC}"
    
    # 后台播放音乐
    mpv --no-video "$music" &
    local mpv_pid=$!
    
    # 监听键盘输入
    while ps -p $mpv_pid > /dev/null; do
      read -t 1 -n 1 -r key
      case $key in
        p|P) # 暂停/继续
          pkill -STOP mpv || pkill -CONT mpv
          ;;
        s|S) # 停止播放
          kill $mpv_pid
          echo -e "${YELLOW}播放已停止${NC}"
          return
          ;;
      esac
    done
  else
    pkg install mpv -y
    if command -v mpv &>/dev/null; then
      play_music "$music"
    else
      echo -e "${RED}无法安装mpv播放器！${NC}"
    fi
  fi
}

# 在线音乐播放
play_online_music() {
  local url="$1"
  if [ -z "$url" ]; then
    echo -e "${RED}URL不能为空！${NC}"
    return
  fi

  # 添加到播放列表
  echo "$url" >> "$PLAYLIST_FILE"
  echo -e "${GREEN}已添加到播放列表！${NC}"
  
  # 播放音乐
  play_music "$url"
}

# 本地音乐播放
play_local_music() {
  echo -e "${YELLOW}正在扫描音乐文件...${NC}"
  local file_list=()
  while IFS= read -r -d $'\0' file; do
    file_list+=("$file")
  done < <(find $HOME/ -type f \( -iname "*.mp3" -o -iname "*.ogg" -o -iname "*.flac" \) -print0 2>/dev/null)
  
  if [ ${#file_list[@]} -eq 0 ]; then
    echo -e "${RED}未找到音乐文件！${NC}"
    return
  fi
  
  # 显示文件列表
  for i in "${!file_list[@]}"; do
    echo "$((i+1)). ${file_list[$i]}"
  done | lolcat
  
  read -p "请输入文件编号: " file_num
  local real_index=$((file_num-1))
  
  if [ $real_index -ge 0 ] && [ $real_index -lt ${#file_list[@]} ]; then
    local music_file="${file_list[$real_index]}"
    # 添加到播放列表
    echo "$music_file" >> "$PLAYLIST_FILE"
    echo -e "${GREEN}已添加到播放列表！${NC}"
    play_music "$music_file"
  else
    echo -e "${RED}无效选择！${NC}"
  fi
}

# 播放整个播放列表
play_playlist() {
  if [ ! -f "$PLAYLIST_FILE" ] || [ ! -s "$PLAYLIST_FILE" ]; then
    echo -e "${RED}播放列表为空！${NC}"
    return
  fi
  
  # 读取播放列表到数组
  mapfile -t playlist < "$PLAYLIST_FILE"
  local current_index=0
  local loop_mode=2  # 0: 顺序播放, 1: 单曲循环, 2: 列表循环
  
  while [ $current_index -lt ${#playlist[@]} ]; do
    local music="${playlist[$current_index]}"
    
    # 播放当前音乐
    clear
    welcome_banner
    echo -e "${PURPLE}正在播放: $(basename "$music")${NC}"
    echo -e "${CYAN}进度: $((current_index+1))/${#playlist[@]}${NC}"
    echo -e "${YELLOW}循环模式: $(get_loop_mode_name $loop_mode)${NC}"
    
    # 后台播放音乐
    if command -v mpv &>/dev/null; then
      mpv --no-video "$music" &
    else
      echo -e "${RED}未找到mpv播放器！${NC}"
      return
    fi
    local mpv_pid=$!
    
    # 显示控制菜单
    while ps -p $mpv_pid > /dev/null; do
      echo -e "\n${BLUE}======= 播放控制 =======${NC}"
      echo -e "1. 暂停/继续"
      echo -e "2. 下一首"
      echo -e "3. 上一首"
      echo -e "4. 切换循环模式"
      echo -e "5. 停止播放"
      echo -e "${BLUE}=======================${NC}"
      
      read -t 1 -n 1 -r control
      if [ -n "$control" ]; then
        case $control in
          1) # 暂停/继续
            pkill -STOP mpv || pkill -CONT mpv
            ;;
          2) # 下一首
            kill $mpv_pid
            current_index=$((current_index+1))
            [ $current_index -ge ${#playlist[@]} ] && current_index=0
            break
            ;;
          3) # 上一首
            kill $mpv_pid
            current_index=$((current_index-1))
            [ $current_index -lt 0 ] && current_index=$((${#playlist[@]}-1))
            break
            ;;
          4) # 切换循环模式
            loop_mode=$(( (loop_mode + 1) % 3 ))
            echo -e "\n${GREEN}循环模式已切换为: $(get_loop_mode_name $loop_mode)${NC}"
            ;;
          5) # 停止播放
            kill $mpv_pid
            echo -e "${YELLOW}播放已停止${NC}"
            return
            ;;
        esac
      fi
    done
    
    # 等待音乐播放结束
    wait $mpv_pid 2>/dev/null
    
    # 根据循环模式更新索引
    case $loop_mode in
      0) # 顺序播放
        current_index=$((current_index+1))
        ;;
      1) # 单曲循环
        # 保持当前索引不变
        ;;
      2) # 列表循环
        current_index=$(( (current_index+1) % ${#playlist[@]} ))
        ;;
    esac
  done
}

# 搜索本地音乐
search_local_music() {
  if [ -f ~/pinkshell/bin/search_utils.sh ]; then
    source ~/pinkshell/bin/search_utils.sh
    search_local_music_impl
  else
    echo -e "${RED}搜索工具未找到！${NC}"
  fi
}

# 搜索本地视频
search_local_videos() {
  if [ -f ~/pinkshell/bin/search_utils.sh ]; then
    source ~/pinkshell/bin/search_utils.sh
    search_local_videos_impl
  else
    echo -e "${RED}搜索工具未找到！${NC}"
  fi
}

# 播放列表管理
manage_playlist() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 播放列表管理 ==========${NC}"
    
    # 显示当前播放列表
    echo -e "${GREEN}当前播放列表:${NC}"
    if [ -f "$PLAYLIST_FILE" ] && [ -s "$PLAYLIST_FILE" ]; then
      nl -w 2 -s '. ' "$PLAYLIST_FILE" | lolcat
    else
      echo -e "${YELLOW}播放列表为空${NC}"
    fi
    
    echo -e "\n1. 播放整个列表"
    echo -e "2. 清空播放列表"
    echo -e "3. 删除指定歌曲"
    echo -e "0. 返回"
    echo -e "${BLUE}=================================${NC}"
    
    read -p "请选择: " choice
    case $choice in
      1)
        if [ -f "$PLAYLIST_FILE" ] && [ -s "$PLAYLIST_FILE" ]; then
          play_playlist
        else
          echo -e "${RED}播放列表为空！${NC}"
          sleep 1
        fi
        ;;
      2)
        > "$PLAYLIST_FILE"
        echo -e "${GREEN}播放列表已清空！${NC}"
        sleep 1
        ;;
      3)
        if [ -f "$PLAYLIST_FILE" ] && [ -s "$PLAYLIST_FILE" ]; then
          read -p "请输入要删除的歌曲编号: " song_num
          if [[ "$song_num" =~ ^[0-9]+$ ]] && [ "$song_num" -gt 0 ] && [ "$song_num" -le $(wc -l < "$PLAYLIST_FILE") ]; then
            sed -i "${song_num}d" "$PLAYLIST_FILE"
            echo -e "${GREEN}已删除第 ${song_num} 首歌曲！${NC}"
          else
            echo -e "${RED}无效的歌曲编号！${NC}"
          fi
        else
          echo -e "${RED}播放列表为空！${NC}"
        fi
        sleep 1
        ;;
      0)
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 娱乐功能菜单
fun_tools() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 娱乐功能 ==========${NC}"
    echo -e "1. 猜数字小游戏"
    echo -e "2. 音乐播放器"
    echo -e "3. 视频播放器"
    echo -e "4. 趣味文本生成"
    echo -e "5. 泠泠笑话"
    echo -e "6. 计算器"
    echo -e "7. 单位转换器"
    echo -e "8. 天气查询"
    echo -e "9. 星座运势"
    echo -e "10. 文件管理器"
    echo -e "0. 返回主菜单\n"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${PURPLE}猜数字小游戏${NC}"
        number=$((RANDOM % 100 + 1))
        echo -e "我已经想了一个1-100之间的数字，猜猜是多少？"
        attempts=0

        while true; do
          read -p "你的猜测: " guess
          ((attempts++))

          if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}请输入有效数字！${NC}"
            continue
          fi

          if [ "$guess" -lt "$number" ]; then
            echo -e "${YELLOW}太小了！再试一次。${NC}"
          elif [ "$guess" -gt "$number" ]; then
            echo -e "${YELLOW}太大了！再试一次。${NC}"
          else
            echo -e "${GREEN}恭喜！你在 ${attempts} 次尝试后猜对了！${NC}"
            break
          fi
        done
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        echo -e "${PURPLE}音乐播放器${NC}"
        echo -e "1. 在线播放"
        echo -e "2. 本地播放"
        echo -e "3. 播放列表管理"
        echo -e "4. 搜索本地音乐"
        read -p "请选择: " music_choice

        case $music_choice in
          1)
            read -p "请输入音乐URL: " music_url
            if [ -z "$music_url" ]; then
              echo -e "${RED}URL不能为空！${NC}"
              sleep 1
              continue
            fi
            play_online_music "$music_url"
            ;;
          2)
            play_local_music
            ;;
          3)
            manage_playlist
            ;;
          4)
            search_local_music
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        ;;
      3)
        echo -e "${PURPLE}视频播放器${NC}"
        echo -e "1. 指定路径播放"
        echo -e "2. 搜索本地视频"
        read -p "请选择: " video_choice

        case $video_choice in
          1)
            read -p "请输入视频URL或本地路径: " video_path
            if [ -z "$video_path" ]; then
              echo -e "${RED}路径不能为空！${NC}"
              sleep 1
              continue
            fi

        if command -v mpv &>/dev/null; then
          echo -e "${YELLOW}正在播放视频...${NC}"
          mpv "$video_path"
        else
          pkg install mpv -y
          echo -e "${YELLOW}正在播放视频...${NC}"
          mpv "$video_path"
        fi
        ;;
      2)
        search_local_videos
        ;;
      *)
        echo -e "${RED}无效选择！${NC}"
        ;;
    esac
    read -p "按回车键返回..."
    ;;
        ;;
      4)
        echo -e "${GREEN}趣味文本生成器${NC}"
        echo -e "1. ASCII艺术"
        echo -e "2. 随机名言"
        echo -e "3. 泠泠专属"
        read -p "请选择: " text_choice

        case $text_choice in
          1)
            if command -v figlet &>/dev/null; then
              read -p "请输入文本: " input_text
              figlet "$input_text" | lolcat
            else
              pkg install figlet -y
              read -p "请输入文本: " input_text
              figlet "$input_text" | lolcat
            fi
            ;;
          2)
            quotes=(
              "代码如诗，逻辑如画，编程是艺术与科学的完美结合。"
              "在0和1的世界里，你是唯一的变量。"
              "每个bug都是成长的机会，每个错误都是进步的阶梯。"
              "编程不是工作，而是创造世界的魔法。"
              "一行代码，一份热爱；一个算法，一份执着。"
            )
            random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
            echo -e "\n${PURPLE}「 ${random_quote} 」${NC}" | lolcat
            ;;
          3)
            echo -e "${CYAN}"
            echo "   ██╗  ██╗ █████╗ ███████╗██╗  ██╗██╗   ██╗"
            echo "   ██║  ██║██╔══██╗╚══███╔╝██║  ██║██║   ██║"
            echo "   ███████║███████║  ███╔╝ ███████║██║   ██║"
            echo "   ██╔══██║██╔══██║ ███╔╝  ██╔══██║██║   ██║"
            echo "   ██║  ██║██████║███████╗██║  ██║╚██████╔╝"
            echo "   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ "
            echo -e "${NC}"
            echo -e "${PURPLE}         快手啊泠好困想睡觉${NC}" | lolcat
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      5)
        jokes=(
          "为什么程序员喜欢黑暗模式？因为光会吸引bug！"
          "为什么程序员分不清万圣节和圣诞节？因为Oct 31 == Dec 25！"
          "泠泠写代码时最常说的一句话：'这个bug昨天还没有呢！'"
          "程序员最浪漫的情话：'你是我生命中的唯一常量'"
          "泠泠的编程哲学：如果第一次没成功，那就Ctrl+C, Ctrl+V"
        )
        random_joke=${jokes[$RANDOM % ${#jokes[@]}]}
        echo -e "\n${YELLOW}${random_joke}${NC}" | lolcat
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      0)
        main_menu
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 个性化设置菜单
personal_settings() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 个性化设置 ==========${NC}"
    echo -e "1. 更改主题颜色"
    echo -e "2. 设置终端字体"
    echo -e "3. 编辑配置文件"
    echo -e "4. 设置泠泠专属提示符"
    echo -e "0. 返回主菜单\n"
    echo -e "${BLUE}================================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${GREEN}请选择主题颜色:${NC}"
        echo -e "1. 少女粉"
        echo -e "2. 星空紫"
        echo -e "3. 海洋蓝"
        echo -e "4. 森林绿"
        echo -e "5. 深色主题"
        echo -e "6. 浅色主题"
        read -p "请选择: " theme_choice

        case $theme_choice in
          1)
            termux-change-color -s pink
            echo -e "${GREEN}已切换为少女粉主题${NC}"
            ;;
          2)
            termux-change-color -s purple
            echo -e "${GREEN}已切换为星空紫主题${NC}"
            ;;
          3)
            termux-change-color -s blue
            echo -e "${GREEN}已切换为海洋蓝主题${NC}"
            ;;
          4)
            termux-change-color -s green
            echo -e "${GREEN}已切换为森林绿主题${NC}"
            ;;
          5)
            termux-change-color -s dark
            echo -e "${GREEN}已切换为深色主题${NC}"
            ;;
          6)
            termux-change-color -s light
            echo -e "${GREEN}已切换为浅色主题${NC}"
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      2)
        echo -e "${GREEN}请选择终端字体:${NC}"
        # 列出可用字体并选择
        if ! command -v termux-font &>/dev/null; then
          pkg install termux-font -y
        fi
        
        echo -e "1. FiraCode (程序员最爱)"
        echo -e "2. Meslo (清晰易读)"
        echo -e "3. SourceCodePro (专业字体)"
        echo -e "4. Hack (简洁现代)"
        read -p "请选择字体: " font_choice
        
        case $font_choice in
          1) termux-font -f firacode ;;
          2) termux-font -f meslo ;;
          3) termux-font -f sourcecodepro ;;
          4) termux-font -f hack ;;
          *) echo -e "${RED}无效选择！${NC}" ;;
        esac
        
        echo -e "${GREEN}字体已更改，重启Termux生效${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      3)
        if [ ! -d $HOME/.pinkshell/.config ]; then
          mkdir -p $HOME/.pinkshell/.config
        fi
        
        echo -e "${GREEN}编辑配置文件...${NC}"
        echo -e "1. 主配置文件"
        echo -e "2. 工具箱配置"
        read -p "请选择: " config_choice
        
        case $config_choice in
          1)
            nano $HOME/.pinkshell/.config/config.conf
            echo -e "${GREEN}主配置已保存${NC}"
            ;;
          2)
            nano $HOME/pinkshell/bin/menu.sh
            echo -e "${GREEN}工具箱配置已保存${NC}"
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      4)
        echo -e "${PURPLE}正在设置泠泠专属提示符...${NC}"
        # 设置专属提示符
        if grep -q "泠泠专属提示符" $HOME/.bashrc; then
          sed -i '/泠泠专属提示符/d' $HOME/.bashrc
        fi
        
        echo -e "\n# 泠泠专属提示符" >> $HOME/.bashrc
        echo "PS1='\[\e[1;35m\]泠泠\[\e[0m\]@\[\e[1;36m\]\h \[\e[1;33m\]\w \[\e[1;35m\]❯\[\e[0m\] '" >> $HOME/.bashrc
        
        echo -e "${GREEN}专属提示符已设置！重启后生效${NC}"
        echo -e "${YELLOW}提示: 输入 'source $HOME/.bashrc' 立即生效${NC}"
        echo -e "\n${CYAN}按任意键返回...${NC}"
        read -n 1 -s
        ;;
      0)
        main_menu
        return
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 主菜单
main_menu() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 主菜单 ==========${NC}"
    echo -e "1. 系统工具"
    echo -e "2. 网络工具"
    echo -e "3. 开发工具"
    echo -e "4. 娱乐功能"
    echo -e "5. 个性化设置"
    echo -e "0. 退出\n"
    echo -e "${BLUE}==========================${NC}"
    echo -e "${PURPLE}输入【泠】触发彩蛋${NC}"
    echo -e "${GREEN}提示: 退出后输入'泠'可重新打开菜单${NC}"

    read -p "请输入选项 : " choice
    
    # 彩蛋触发
    if [ "$choice" = "泠" ]; then
      show_easter_egg
      continue
    fi
    
    case $choice in
      1) system_tools ;;
      2) network_tools ;;
      3) dev_tools ;;
      4) fun_tools ;;
      5) personal_settings ;;
      0)
        echo -e "${GREEN}感谢使用Pinkshell！再见！${NC}"
        return 0
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 启动脚本
check_dependencies

# 检查是否从终端直接运行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_menu
fi
