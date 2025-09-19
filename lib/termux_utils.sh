#!/bin/bash
# 功能库

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; PURPLE='\033[1;35m'; CYAN='\033[1;36m'
NC='\033[0m'
BLINK='\033[5m'

# 磁盘分析工具
disk_analysis() {
    echo -e "${PURPLE}[快手啊泠]的磁盘分析工具${NC}"
    df -h | awk 'NR==1{print $0}NR>1{print $0 | "sort -k5 -rn"}' | head -n 6
    echo -e "${YELLOW}按回车返回菜单...${NC}"; read
}

# 进程管理工具
process_manager() {
    echo -e "\n${CYAN}► 按 ${RED}Q ${CYAN}退出 ◄${NC}"
    top -n 1 | head -15
    echo -e "${YELLOW}按回车返回菜单...${NC}"; read
}

# 网络工具示例（占位）
network_tools() {
    echo -e "${GREEN}网络工具模块开发中...${NC}"
    sleep 1
}

# 开发工具示例（占位）
dev_tools() {
    echo -e "${GREEN}开发工具模块开发中...${NC}"
    sleep 1
}

# 娱乐工具示例（占位）
fun_tools() {
    echo -e "${GREEN}娱乐功能模块开发中...${NC}"
    sleep 1
}

# 个性化设置示例（占位）
personal_settings() {
    echo -e "${GREEN}个性化设置模块开发中...${NC}"
    sleep 1
}

# 彩蛋功能
show_easter_egg() {
    colors=(31 32 33 34 35 36)
    for i in {1..3}; do
        for c in "${colors[@]}"; do
            echo -en "\e[${c}m✿\e[0m"
            sleep 0.1
        done
    done
    echo -e "\n${BLINK}${YELLOW} Pinkshell专属彩蛋激活！ ${NC}"
    sleep 2
}

# 系统信息显示
system_info() {
    echo -e "${CYAN}设备: $(uname -npo)${NC}"
    echo -e "${PURPLE}内核: $(uname -r)${NC}"
    echo -e "${YELLOW}存储: $(df -h / | awk 'NR==2 {print $4}') 可用${NC}"
    echo -e "${GREEN}内存: $(free -m | awk 'NR==2 {print $4}')MB 可用${NC}"
}

# 安装依赖
install_dependencies() {
    # 检查lolcat
    if ! command -v lolcat &> /dev/null; then
        echo -e "${YELLOW}正在安装lolcat...${NC}"
        pkg update -y && pkg install -y ruby
        gem install lolcat
    fi
    
    # 检查其他可能需要的工具
    for tool in curl wget neofetch mpv aria2 nmap; do
        if ! command -v $tool &> /dev/null; then
            pkg install -y $tool
        fi
    done
}

# 显示随机名言
random_quote() {
    quotes=(
        "代码如诗，逻辑如画，编程是艺术与科学的完美结合。"
        "在0和1的世界里，你是唯一的变量。"
        "每个bug都是成长的机会，每个错误都是进步的阶梯。"
        "编程不是工作，而是创造世界的魔法。"
        "一行代码，一份热爱；一个算法，一份执着。"
    )
    random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
    echo -e "\n${PURPLE}「 ${random_quote} 」${NC}" | lolcat
}

# 显示泠泠笑话
ling_joke() {
    jokes=(
        "为什么程序员喜欢黑暗模式？因为光会吸引bug！"
        "为什么程序员分不清万圣节和圣诞节？因为Oct 31 == Dec 25！"
        "泠泠写代码时最常说的一句话：'这个bug昨天还没有呢！'"
        "程序员最浪漫的情话：'你是我生命中的唯一常量'"
        "泠泠的编程哲学：如果第一次没成功，那就Ctrl+C, Ctrl+V"
    )
    random_joke=${jokes[$RANDOM % ${#jokes[@]}]}
    echo -e "\n${YELLOW}${random_joke}${NC}" | lolcat
}