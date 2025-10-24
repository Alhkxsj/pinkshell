# 文件管理器
file_manager_impl() {
  local current_dir="$HOME"
  
  while true; do
    clear
    echo -e "${BLUE}========== 文件管理器 ==========${NC}"
    echo -e "${YELLOW}当前目录: $current_dir${NC}"
    echo -e "${GREEN}目录列表:${NC}"
    
    # 显示目录内容
    local items=()
    local i=1
    while IFS= read -r item; do
      items+=("$item")
    done < <(ls -1 "$current_dir" 2>/dev/null | head -n 20)
    
    for item in "${items[@]}"; do
      if [ -d "$current_dir/$item" ]; then
        echo -e "${CYAN}$i.${NC} [DIR] $item"
      else
        echo -e "${CYAN}$i.${NC} [FILE] $item"
      fi
      ((i++))
    done
    
    echo ""
    echo -e "${BLUE}==============================${NC}"
    echo -e "0. 返回上级目录"
    echo -e "q. 退出文件管理器"
    echo ""
    
    read -p "请选择文件/目录编号 (或 q 退出): " choice
    
    case $choice in
      q|Q)
        return
        ;;
      0)
        # 返回上级目录
        current_dir=$(dirname "$current_dir")
        ;;
      *)
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#items[@]} ]; then
          local selected_item="${items[$((choice-1))]}"
          local full_path="$current_dir/$selected_item"
          
          if [ -d "$full_path" ]; then
            # 进入子目录
            current_dir="$full_path"
          elif [ -f "$full_path" ]; then
            # 显示文件信息
            echo -e "${GREEN}文件信息:${NC}"
            ls -lh "$full_path"
            echo ""
            read -p "按回车键继续..."
          fi
        else
          echo -e "${RED}无效选择！${NC}"
          sleep 1
        fi
        ;;
    esac
  done
}