#!/data/data/com.termux/files/usr/bin/bash
# [快手啊泠好困想睡觉]专属Termux工具箱 v3.5


# 加载功能库
source ~/pinkshell/lib/termux_utils.sh

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
  # 新增：检查工具安装标记
  if [ -f ~/.pinkshell/tools_installed ]; then
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
      pkg install -y $tool
    fi
  done

  # 新增：运行工具安装器
  echo -e "${PURPLE}[少女终端] 正在运行工具安装器...${NC}"
  bash ~/pinkshell/bin/tools_install.sh
}

# 动态标题
welcome_banner() {
  clear
  # 兼容模式：当lolcat不可用时使用普通颜色
  if command -v lolcat &>/dev/null; then
    echo -e "${PURPLE}
    ░█▀▀░█▀█░█░█░▀█▀░█▀▀░█▀▄   ░█▀▀░█▀█░█▀▄░█▀▀
    ░█▀▀░█░█░█░█░░█░░█▀▀░█▀▄   ░█▀▀░█░█░█░█░█▀▀
    ░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀░▀   ░▀▀▀░▀▀▀░▀▀▀░▀▀▀
    ${NC}" | lolcat -p 0.6
  else
    echo -e "${PURPLE}
    ░█▀▀░█▀█░█░█░▀█▀░█▀▀░█▀▄   ░█▀▀░█▀█░█▀▄░█▀▀
    ░█▀▀░█░█░█░█░░█░░█▀▀░█▀▄   ░█▀▀░█░█░█░█░█▀▀
    ░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀░▀   ░▀▀▀░▀▀▀░▀▀▀░▀▀▀
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
  echo -e "\n${RED}❤ ${YELLOW}欢迎作者 ${RED}快手啊泠好困想睡觉 ${YELLOW}❤${NC}"
  for i in {1..5}; do
    echo -en "${CYAN}✿${PURPLE}❀${GREEN}✤${NC}"
    sleep 0.2
  done
  echo -e "\n${YELLOW}专属彩蛋已触发！${NC}"

  # 显示系统信息
  if command -v neofetch &>/dev/null; then
    neofetch | lolcat
  else
    echo -e "${GREEN}系统信息:${NC}"
    echo -e "${CYAN}设备: $(uname -npo)${NC}"
    echo -e "${PURPLE}内核: $(uname -r)${NC}"
    echo -e "${YELLOW}存储: $(df -h / | awk 'NR==2 {print $4}') 可用${NC}"
  fi

  # 显示随机名言
  quotes=(
    "代码如诗，逻辑如画，编程是艺术与科学的完美结合。"
    "在0和1的世界里，你是唯一的变量。"
    "每个bug都是成长的机会，每个错误都是进步的阶梯。"
    "编程不是工作，而是创造世界的魔法。"
    "一行代码，一份热爱；一个算法，一份执着。"
  )
  random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
  echo -e "\n${PURPLE}「 ${random_quote} 」${NC}" | lolcat

  sleep 4
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
        read -p "按回车键返回..."
        ;;
      2)
        echo -e "${GREEN}存储空间分析:${NC}"
        # 显示更详细的存储信息
        echo -e "${CYAN}文件系统使用情况:${NC}"
        df -h | awk 'NR==1{print $0}NR>1{print $0 | "sort -k5 -rn"}' | head -n 6 | lolcat
        echo -e "\n${CYAN}目录大小排行:${NC}"
        du -h -d 1 ~/ 2>/dev/null | sort -hr | head -n 10 | lolcat
        read -p "按回车键返回..."
        ;;
      3)
        process_manager
        ;;
      4)
        echo -e "${CYAN}正在更新系统...${NC}"
        pkg update -y && pkg upgrade -y
        read -p "更新完成，按回车键返回..."
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
    grep -oP '(?<=@).*' $PREFIX/etc/apt/sources.list || echo "默认源"
    
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
        read -p "按回车键返回..."
        ;;
      2)
        echo -e "${CYAN}正在更换为阿里云源...${NC}"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.aliyun.com/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为阿里云源！${NC}"
        read -p "按回车键返回..."
        ;;
      3)
        echo -e "${CYAN}正在更换为南京大学源...${NC}"
        sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirror.nju.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为南京大学源！${NC}"
        read -p "按回车键返回..."
        ;;
      4)
        echo -e "${CYAN}正在更换为官方源...${NC}"
        sed -i 's@^#deb\(.*\)@deb\1@' $PREFIX/etc/apt/sources.list
        pkg update -y
        echo -e "${GREEN}已成功更换为官方源！${NC}"
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
    echo -e "0. 返回主菜单\n"
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
        ;;
      3)
        read -p "请输入要扫描的IP或域名: " target
        if [ -z "$target" ]; then
          target="127.0.0.1"
        fi

        if command -v nmap &>/dev/null; then
          echo -e "${YELLOW}正在扫描 $target ...${NC}"
          nmap -T4 $target | lolcat
        else
          echo -e "${CYAN}正在安装nmap...${NC}"
          pkg install nmap -y
          nmap -T4 $target | lolcat
        fi
        read -p "按回车键返回..."
        ;;
      4)
        read -p "请输入下载链接: " url
        if [ -z "$url" ]; then
          echo -e "${RED}下载链接不能为空！${NC}"
          sleep 1
          continue
        fi

        if command -v aria2c &>/dev/null; then
          echo -e "${YELLOW}正在使用aria2下载...${NC}"
          aria2c -x 16 $url
        else
          echo -e "${CYAN}正在安装aria2...${NC}"
          pkg install aria2 -y
          aria2c -x 16 $url
        fi
        read -p "按回车键返回..."
        ;;
      5)
        echo -e "${GREEN}网络诊断信息:${NC}"
        echo -e "${CYAN}网络连接状态:${NC}"
        echo -e "${YELLOW}正在测试与Google的连接...${NC}"
        ping -c 4 google.com | lolcat
        
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
        ;;
      2)
        echo -e "${PURPLE}音乐播放器${NC}"
        echo -e "1. 在线播放"
        echo -e "2. 本地播放"
        read -p "请选择: " music_choice

        case $music_choice in
          1)
            read -p "请输入音乐URL: " music_url
            if [ -z "$music_url" ]; then
              echo -e "${RED}URL不能为空！${NC}"
              sleep 1
              continue
            fi

            if command -v mpv &>/dev/null; then
              echo -e "${YELLOW}正在播放音乐...${NC}"
              mpv "$music_url"
            else
              pkg install mpv -y
              echo -e "${YELLOW}正在播放音乐...${NC}"
              mpv "$music_url"
            fi
            ;;
          2)
            echo -e "${YELLOW}正在扫描音乐文件...${NC}"
            find ~/ -type f \( -iname "*.mp3" -o -iname "*.ogg" -o -iname "*.flac" \) 2>/dev/null | nl | lolcat
            read -p "请输入文件编号: " file_num
            music_file=$(find ~/ -type f \( -iname "*.mp3" -o -iname "*.ogg" -o -iname "*.flac" \) 2>/dev/null | sed -n "${file_num}p")

            if [ -z "$music_file" ]; then
              echo -e "${RED}无效选择！${NC}"
              sleep 1
              continue
            fi

            echo -e "${YELLOW}正在播放音乐...${NC}"
            mpv "$music_file"
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        read -p "按回车键返回..."
        ;;
      3)
        echo -e "${PURPLE}视频播放器${NC}"
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
        read -p "按回车键返回..."
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
            echo "   ██║  ██║██║  ██║███████╗██║  ██║╚██████╔╝"
            echo "   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ "
            echo -e "${NC}"
            echo -e "${PURPLE}         快手啊泠好困想睡觉${NC}" | lolcat
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
    echo -e "5. 设置启动别名"
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
        sleep 1
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
        sleep 1
        ;;
      3)
        if [ ! -d ~/.pinkshell/.config ]; then
          mkdir -p ~/.pinkshell/.config
        fi
        
        echo -e "${GREEN}编辑配置文件...${NC}"
        echo -e "1. 主配置文件"
        echo -e "2. 工具箱配置"
        read -p "请选择: " config_choice
        
        case $config_choice in
          1)
            nano ~/.pinkshell/.config/config.conf
            echo -e "${GREEN}主配置已保存${NC}"
            ;;
          2)
            nano ~/pinkshell/bin/menu.sh
            echo -e "${GREEN}工具箱配置已保存${NC}"
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        
        sleep 1
        ;;
      4)
        echo -e "${PURPLE}正在设置泠泠专属提示符...${NC}"
        # 设置专属提示符
        if grep -q "泠泠专属提示符" ~/.bashrc; then
          sed -i '/泠泠专属提示符/d' ~/.bashrc
        fi
        
        echo -e "\n# 泠泠专属提示符" >> ~/.bashrc
        echo "PS1='\[\e[1;35m\]泠泠\[\e[0m\]@\[\e[1;36m\]\h \[\e[1;33m\]\w \[\e[1;35m\]❯\[\e[0m\] '" >> ~/.bashrc
        
        echo -e "${GREEN}专属提示符已设置！重启后生效${NC}"
        echo -e "${YELLOW}提示: 输入 'source ~/.bashrc' 立即生效${NC}"
        sleep 2
        ;;
      5)
        setup_autostart
        read -p "按回车键返回..."
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

# 设置别名
setup_aliases() {
  # 设置别名，以便在命令行输入"泠"启动菜单
  if ! grep -q "alias 泠" ~/.bashrc; then
    echo "alias 泠='bash \$HOME/pinkshell/bin/menu.sh'" >> ~/.bashrc
  fi

  # 添加其他实用别名
  if ! grep -q "alias 更新" ~/.bashrc; then
    echo "alias 更新='pkg update && pkg upgrade'" >> ~/.bashrc
  fi

  if ! grep -q "alias 清理" ~/.bashrc; then
    echo "alias 清理='pkg clean'" >> ~/.bashrc
  fi

  if ! grep -q "alias 存储" ~/.bashrc; then
    echo "alias 存储='df -h'" >> ~/.bashrc
  fi

  echo -e "${GREEN}别名已设置！${NC}"
  echo -e "${YELLOW}可使用的别名:${NC}"
  echo -e "  泠    - 打开泠泠菜单"
  echo -e "  更新  - 更新系统"
  echo -e "  清理  - 清理缓存"
  echo -e "  存储  - 查看存储空间"
  echo -e "${CYAN}执行以下命令立即生效:${NC}"
  echo -e "source ~/.bashrc"
  read -p "按回车键返回..."
}

# 自启动设置
setup_autostart() {
  # 确保脚本可执行
  chmod +x "$0"

  # 添加到bashrc以实现启动Termux时运行菜单
  if ! grep -q "pinkshell/bin/menu.sh" ~/.bashrc; then
    echo -e "\n# 启动泠泠菜单" >> ~/.bashrc
    echo "if [ -f \"\$HOME/pinkshell/bin/menu.sh\" ]; then" >> ~/.bashrc
    echo "    bash \"\$HOME/pinkshell/bin/menu.sh\"" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
  fi

  # 设置常用别名
  setup_aliases

  # 提示
  echo -e "${GREEN}自启动和别名已设置！${NC}"
  echo -e "${YELLOW}1. 重启Termux后会自动启动菜单${NC}"
  echo -e "${YELLOW}2. 任何时候在终端输入 '泠' 可打开菜单${NC}"
  echo -e "${CYAN}执行以下命令立即生效:${NC}"
  echo -e "source ~/.bashrc"
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
    case $choice in
      1) system_tools ;;
      2) network_tools ;;
      3) dev_tools ;;
      4) fun_tools ;;
      5) personal_settings ;;
      0)
        echo -e "${YELLOW}再见！泠泠会想你的~${NC}"
        echo -e "${CYAN}提示: 任何时候输入 '泠' 可重新打开菜单${NC}"
        exit 0
        ;;
      泠)
        show_easter_egg
        ;;
      *)
        echo -e "${RED}无效输入！${NC}"
        sleep 1
        ;;
    esac
  done
}

# 初始化
check_dependencies
welcome_banner

# 检查是否设置了别名，如果没有则提示
if ! grep -q "alias 泠" ~/.bashrc; then
  echo -e "${YELLOW}首次使用建议设置自启动和别名:${NC}"
  read -p "是否设置自启动和别名? [y/n] " choice
  if [[ "$choice" =~ [yY] ]]; then
    setup_autostart
    echo -e "${GREEN}设置完成！请执行 'source ~/.bashrc' 或重启Termux${NC}"
    sleep 2
  fi
fi

# 启动主菜单
main_menu
