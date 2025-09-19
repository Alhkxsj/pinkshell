#!/data/data/com.termux/files/usr/bin/bash
# 系统工具模块

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
        read -p "按回车键返回..."
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
        read -p "按回车键返回..."
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
  read -p "按回车键返回..."
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
        echo -e "${CYAN}文件系统使用情况:${NC}"
        df -h | awk 'NR==1{print $0}NR>1{print $0 | "sort -k5 -rn"}' | head -n 6 | lolcat
        echo -e "\n${CYAN}目录大小排行:${NC}"
        du -h -d 1 $HOME/ 2>/dev/null | sort -hr | head -n 10 | lolcat
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