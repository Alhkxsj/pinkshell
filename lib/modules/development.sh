#!/data/data/com.termux/files/usr/bin/bash
# 开发工具模块

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