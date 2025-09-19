#!/data/data/com.termux/files/usr/bin/bash
# 个性化设置模块

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
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s pink
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#FF69B4\007"  # 红色
              echo -e "\033]4;2;#FF1493\007"  # 绿色
              echo -e "\033]4;3;#FF69B4\007"  # 黄色
              echo -e "\033]4;4;#FF69B4\007"  # 蓝色
              echo -e "\033]4;5;#FF69B4\007"  # 紫色
              echo -e "\033]4;6;#FF69B4\007"  # 青色
            fi
            echo -e "${GREEN}已切换为少女粉主题${NC}"
            ;;
          2)
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s purple
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#9370DB\007"  # 红色
              echo -e "\033]4;2;#8A2BE2\007"  # 绿色
              echo -e "\033]4;3;#9370DB\007"  # 黄色
              echo -e "\033]4;4;#9370DB\007"  # 蓝色
              echo -e "\033]4;5;#9370DB\007"  # 紫色
              echo -e "\033]4;6;#9370DB\007"  # 青色
            fi
            echo -e "${GREEN}已切换为星空紫主题${NC}"
            ;;
          3)
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s blue
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#1E90FF\007"  # 红色
              echo -e "\033]4;2;#00BFFF\007"  # 绿色
              echo -e "\033]4;3;#1E90FF\007"  # 黄色
              echo -e "\033]4;4;#1E90FF\007"  # 蓝色
              echo -e "\033]4;5;#1E90FF\007"  # 紫色
              echo -e "\033]4;6;#1E90FF\007"  # 青色
            fi
            echo -e "${GREEN}已切换为海洋蓝主题${NC}"
            ;;
          4)
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s green
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#32CD32\007"  # 红色
              echo -e "\033]4;2;#228B22\007"  # 绿色
              echo -e "\033]4;3;#32CD32\007"  # 黄色
              echo -e "\033]4;4;#32CD32\007"  # 蓝色
              echo -e "\033]4;5;#32CD32\007"  # 紫色
              echo -e "\033]4;6;#32CD32\007"  # 青色
            fi
            echo -e "${GREEN}已切换为森林绿主题${NC}"
            ;;
          5)
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s dark
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#FF4136\007"  # 红色
              echo -e "\033]4;2;#2ECC40\007"  # 绿色
              echo -e "\033]4;3;#FFDC00\007"  # 黄色
              echo -e "\033]4;4;#0074D9\007"  # 蓝色
              echo -e "\033]4;5;#B10DC9\007"  # 紫色
              echo -e "\033]4;6;#7FDBFF\007"  # 青色
            fi
            echo -e "${GREEN}已切换为深色主题${NC}"
            ;;
          6)
            if command -v termux-change-color &>/dev/null; then
              termux-change-color -s light
            else
              echo -e "${YELLOW}正在使用替代方案...${NC}"
              echo -e "\033]4;1;#FF6B6B\007"  # 红色
              echo -e "\033]4;2;#4ECDC4\007"  # 绿色
              echo -e "\033]4;3;#FFE66D\007"  # 黄色
              echo -e "\033]4;4;#1A535C\007"  # 蓝色
              echo -e "\033]4;5;#FF6B6B\007"  # 紫色
              echo -e "\033]4;6;#4ECDC4\007"  # 青色
            fi
            echo -e "${GREEN}已切换为浅色主题${NC}"
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        read -p "按回车键返回..."
        ;;
      2)
        echo -e "${GREEN}请选择终端字体:${NC}"
        # 列出可用字体并选择
        if ! command -v termux-font &>/dev/null; then
          echo -e "${YELLOW}正在使用替代方案...${NC}"
        fi
        
        echo -e "1. FiraCode (程序员最爱)"
        echo -e "2. Meslo (清晰易读)"
        echo -e "3. SourceCodePro (专业字体)"
        echo -e "4. Hack (简洁现代)"
        read -p "请选择字体: " font_choice
        
        case $font_choice in
          1) 
            if command -v termux-font &>/dev/null; then
              termux-font -f firacode
            else
              echo -e "${GREEN}已选择 FiraCode 字体${NC}"
            fi
            ;;
          2) 
            if command -v termux-font &>/dev/null; then
              termux-font -f meslo
            else
              echo -e "${GREEN}已选择 Meslo 字体${NC}"
            fi
            ;;
          3) 
            if command -v termux-font &>/dev/null; then
              termux-font -f sourcecodepro
            else
              echo -e "${GREEN}已选择 SourceCodePro 字体${NC}"
            fi
            ;;
          4) 
            if command -v termux-font &>/dev/null; then
              termux-font -f hack
            else
              echo -e "${GREEN}已选择 Hack 字体${NC}"
            fi
            ;;
          *) 
            echo -e "${RED}无效选择！${NC}" 
            ;;
        esac
        
        echo -e "${GREEN}字体已更改，重启Termux生效${NC}"
        read -p "按回车键返回..."
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
        
        read -p "按回车键返回..."
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