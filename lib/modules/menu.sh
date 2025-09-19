#!/data/data/com.termux/files/usr/bin/bash
# 主菜单模块

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