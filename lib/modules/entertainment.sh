#!/data/data/com.termux/files/usr/bin/bash
# 娱乐工具模块

# ================== 娱乐功能 ================== #
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
        read -p "按回车键返回..."
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
      4)
        echo -e "${GREEN}趣味文本生成器${NC}"
        echo -e "1. ASCII艺术"
        echo -e "2. 随机名言"
        echo -e "3. 泠泠专属"
        echo -e "4. 彩虹文字"
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
              "代码改变世界，程序创造未来。"
              "程序是写给人读的，只是顺便能在机器上运行。"
              "编程是一种思想，而不是一种语言。"
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
            echo "   ██║  ██║███████║███████╗██║  ██║╚██████╔╝"
            echo "   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ "
            echo -e "${NC}"
            echo -e "${PURPLE}         快手啊泠好困想睡觉${NC}" | lolcat
            ;;
          4)
            read -p "请输入要转换为彩虹文字的文本: " rainbow_text
            echo -e "\n${RED}R${YELLOW}A${GREEN}I${CYAN}N${BLUE}B${PURPLE}O${PINK}W ${NC}$rainbow_text${NC}" | lolcat
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
          "为什么程序员总是分不清万圣节和圣诞节？因为 Oct 31 = Dec 25！"
          "程序员的三大美德：懒惰、急躁和傲慢。"
          "为什么程序员喜欢喝茶？因为茶有BUG！"
        )
        random_joke=${jokes[$RANDOM % ${#jokes[@]}]}
        echo -e "\n${YELLOW}${random_joke}${NC}" | lolcat
        read -p "按回车键返回..."
        ;;
      6)
        echo -e "${CYAN}简易计算器${NC}"
        echo -e "${GREEN}支持的运算: + - * / % ^${NC}"
        echo -e "${YELLOW}示例: 2 + 3, 10 * 5, 2 ^ 3${NC}"
        read -p "请输入表达式 (或按回车返回): " expression
        
        if [ -n "$expression" ]; then
          # 使用 bc 进行计算
          if command -v bc &>/dev/null; then
            result=$(echo "scale=2; $expression" | bc 2>/dev/null)
            if [ $? -eq 0 ]; then
              echo -e "${GREEN}结果: $result${NC}"
            else
              echo -e "${RED}计算错误！请输入有效的表达式。${NC}"
            fi
          else
            echo -e "${YELLOW}正在安装计算器...${NC}"
            pkg install bc -y
            result=$(echo "scale=2; $expression" | bc 2>/dev/null)
            if [ $? -eq 0 ]; then
              echo -e "${GREEN}结果: $result${NC}"
            else
              echo -e "${RED}计算错误！请输入有效的表达式。${NC}"
            fi
          fi
        fi
        read -p "按回车键返回..."
        ;;
      7)
        echo -e "${PURPLE}单位转换器${NC}"
        echo -e "1. 温度转换 (C/F/K)"
        echo -e "2. 长度转换 (m/cm/mm)"
        echo -e "3. 重量转换 (kg/g/mg)"
        read -p "请选择: " converter_choice

        case $converter_choice in
          1)
            echo -e "${CYAN}温度转换${NC}"
            echo -e "1. 摄氏度 → 华氏度"
            echo -e "2. 华氏度 → 摄氏度"
            echo -e "3. 摄氏度 → 开尔文"
            read -p "请选择转换类型: " temp_choice
            read -p "请输入温度值: " temp_value

            case $temp_choice in
              1)
                result=$(echo "scale=2; $temp_value * 9 / 5 + 32" | bc)
                echo -e "${GREEN}${temp_value}°C = ${result}°F${NC}"
                ;;
              2)
                result=$(echo "scale=2; ($temp_value - 32) * 5 / 9" | bc)
                echo -e "${GREEN}${temp_value}°F = ${result}°C${NC}"
                ;;
              3)
                result=$(echo "scale=2; $temp_value + 273.15" | bc)
                echo -e "${GREEN}${temp_value}°C = ${result}K${NC}"
                ;;
              *)
                echo -e "${RED}无效选择！${NC}"
                ;;
            esac
            ;;
          2)
            echo -e "${CYAN}长度转换${NC}"
            echo -e "1. 米 → 厘米"
            echo -e "2. 厘米 → 米"
            echo -e "3. 米 → 毫米"
            read -p "请选择转换类型: " length_choice
            read -p "请输入长度值: " length_value

            case $length_choice in
              1)
                result=$(echo "scale=2; $length_value * 100" | bc)
                echo -e "${GREEN}${length_value}m = ${result}cm${NC}"
                ;;
              2)
                result=$(echo "scale=2; $length_value / 100" | bc)
                echo -e "${GREEN}${length_value}cm = ${result}m${NC}"
                ;;
              3)
                result=$(echo "scale=2; $length_value * 1000" | bc)
                echo -e "${GREEN}${length_value}m = ${result}mm${NC}"
                ;;
              *)
                echo -e "${RED}无效选择！${NC}"
                ;;
            esac
            ;;
          3)
            echo -e "${CYAN}重量转换${NC}"
            echo -e "1. 千克 → 克"
            echo -e "2. 克 → 千克"
            echo -e "3. 千克 → 毫克"
            read -p "请选择转换类型: " weight_choice
            read -p "请输入重量值: " weight_value

            case $weight_choice in
              1)
                result=$(echo "scale=2; $weight_value * 1000" | bc)
                echo -e "${GREEN}${weight_value}kg = ${result}g${NC}"
                ;;
              2)
                result=$(echo "scale=2; $weight_value / 1000" | bc)
                echo -e "${GREEN}${weight_value}g = ${result}kg${NC}"
                ;;
              3)
                result=$(echo "scale=2; $weight_value * 1000000" | bc)
                echo -e "${GREEN}${weight_value}kg = ${result}mg${NC}"
                ;;
              *)
                echo -e "${RED}无效选择！${NC}"
                ;;
            esac
            ;;
          *)
            echo -e "${RED}无效选择！${NC}"
            ;;
        esac
        read -p "按回车键返回..."
        ;;
      8)
        echo -e "${BLUE}天气查询${NC}"
        read -p "请输入城市名称 (或按回车查询当前位置): " city
        
        if command -v curl &>/dev/null; then
          if [ -z "$city" ]; then
            echo -e "${YELLOW}正在查询当前位置天气...${NC}"
            curl -s "wttr.in?format=3" | lolcat
          else
            echo -e "${YELLOW}正在查询 ${city} 的天气...${NC}"
            curl -s "wttr.in/${city}?format=3" | lolcat
          fi
        else
          echo -e "${RED}需要安装 curl 才能查询天气${NC}"
        fi
        read -p "按回车键返回..."
        ;;
      9)
        echo -e "${PINK}星座运势${NC}"
        echo -e "请选择你的星座:"
        echo -e "1. 白羊座  2. 金牛座  3. 双子座  4. 巨蟹座"
        echo -e "5. 狮子座  6. 处女座  7. 天秤座  8. 天蝎座"
        echo -e "9. 射手座  10. 摩羯座  11. 水瓶座  12. 双鱼座"
        read -p "请选择 (1-12): " constellation_choice

        # 星座列表
        constellations=("白羊座" "金牛座" "双子座" "巨蟹座" "狮子座" "处女座" "天秤座" "天蝎座" "射手座" "摩羯座" "水瓶座" "双鱼座")
        
        if [[ "$constellation_choice" =~ ^[1-9]|1[0-2]$ ]]; then
          index=$((constellation_choice - 1))
          constellation=${constellations[$index]}
          
          # 生成随机运势
          fortunes=(
            "今天运势很好，适合尝试新事物！"
            "今天可能会遇到一些挑战，但坚持就是胜利。"
            "今天是收获的一天，努力会有回报。"
            "今天适合放松心情，享受生活。"
            "今天可能会有意外的惊喜，保持开放的心态。"
            "今天需要多关注身体健康，适当休息。"
            "今天人际关系很好，适合社交活动。"
            "今天财运不错，可以考虑投资理财。"
            "今天学习能力增强，适合充电提升。"
            "今天创意迸发，适合发挥想象力。"
          )
          
          random_fortune=${fortunes[$RANDOM % ${#fortunes[@]}]}
          
          echo -e "\n${PINK}🔮 ${constellation} 今日运势${NC}"
          echo -e "${YELLOW}${random_fortune}${NC}"
          echo -e "${CYAN}幸运数字: $((RANDOM % 100))${NC}"
          echo -e "${GREEN}幸运颜色: $(echo -e "\033[3$((RANDOM % 7))m")$(echo -e "\033[0m")${NC}"
        else
          echo -e "${RED}无效选择！${NC}"
        fi
        read -p "按回车键返回..."
        ;;
      10)
        if [ -f ~/pinkshell/bin/search_utils.sh ]; then
          source ~/pinkshell/bin/search_utils.sh
          file_manager_impl
        else
          echo -e "${RED}文件管理器未找到！${NC}"
          sleep 1
        fi
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