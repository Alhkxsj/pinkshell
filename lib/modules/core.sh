#!/data/data/com.termux/files/usr/bin/bash
# 核心工具模块

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
welcome_banner() {
  clear
  # 兼容模式：当lolcat不可用时使用普通颜色
  if command -v lolcat &>/dev/null; then
    echo -e "${PURPLE}"
    echo "  _____ _    _ _  __     _____ _          _ _ "
    echo " |  __ (_)  | | |/ /    / ____| |        | | |"
    echo " | |__) | __| | ' / ___| (___ | |__   ___| | |"
    echo " |  ___/ '__| |  < / _ \___ \| '_ \ / _ \ | |"
    echo " | |   | |  | | . \  __/____) | | | |  __/ | |"
    echo " |_|   |_|  |_|_|\_\___|_____/|_| |_|\___|_|_|"
    echo "    _____                    _                        _ "
    echo " |_   _|                  | |                      | |"
    echo "   | | ___ _ __ _ __   ___| |___      _____  _ __ __| |"
    echo "   | |/ _ \ '__| '_ \ / _ \ __\ \ /\ / / _ \| '__/ _` |"
    echo "  _| |  __/ |  | | | |  __/ |_ \ V  V / (_) | | | (_| |"
    echo " |_____\___|_|  |_| |_|\___|\__| \_/\_/ \___/|_|  \__,_|"
    echo -e "${NC}" | lolcat -p 0.6
  else
    echo -e "${PURPLE}"
    echo "  _____ _    _ _  __     _____ _          _ _ "
    echo " |  __ (_)  | | |/ /    / ____| |        | | |"
    echo " | |__) | __| | ' / ___| (___ | |__   ___| | |"
    echo " |  ___/ '__| |  < / _ \___ \| '_ \ / _ \ | |"
    echo " | |   | |  | | . \  __/____) | | | |  __/ | |"
    echo " |_|   |_|  |_|_|\_\___|_____/|_| |_|\___|_|_|"
    echo "    _____                    _                        _ "
    echo " |_   _|                  | |                      | |"
    echo "   | | ___ _ __ _ __   ___| |___      _____  _ __ __| |"
    echo "   | |/ _ \ '__| '_ \ / _ \ __\ \ /\ / / _ \| '__/ _` |"
    echo "  _| |  __/ |  | | | |  __/ |_ \ V  V / (_) | | | (_| |"
    echo " |_____\___|_|  |_| |_|\___|\__| \_/\_/ \___/|_|  \__,_|"
    echo -e "${NC}"
  fi
 |  ___/ '__| |  < / _ \___ \| '_ \ / _ \ | |
 | |   | |  | | . \  __/____) | | | |  __/ | |
 |_|   |_|  |_|_|\_\___|_____/|_| |_|\___|_|_|
    _____                    _                        _ 
 |_   _|                  | |                      | |
   | | ___ _ __ _ __   ___| |___      _____  _ __ __| |
   | |/ _ \ '__| '_ \ / _ \ __\ \ /\ / / _ \| '__/ _` |
  _| |  __/ |  | | | |  __/ |_ \ V  V / (_) | | | (_| |
 |_____|\___|_|  |_| |_|\___|\__| \_/\_/ \___/|_|  \__,_|
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
 |_____|\___|_|  |_| |_|\___|\__| \_/\_/ \___/|_|  \__,_|
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