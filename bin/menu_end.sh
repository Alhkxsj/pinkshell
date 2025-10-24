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
        read -p "按回车键返回..."
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