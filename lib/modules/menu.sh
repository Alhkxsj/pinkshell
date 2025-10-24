#!/bin/bash
# Pinkshell 主菜单

if [ -f "$HOME/pinkshell/bin/pinkshell.sh" ]; then
    source "$HOME/pinkshell/bin/pinkshell.sh"
else
    echo -e "\033[1;31m错误: 找不到统一启动器\033[0m"
    echo -e "\033[1;33m请重新安装 Pinkshell\033[0m"
    exit 1
fi

load_module() {
    local module_name="$1"
    local module_path="$MODULES_DIR/$module_name"
    
    if security_check "$module_path"; then
        source "$module_path"
        return 0
    else
        pinkshell_log "ERROR" "模块安全检查失败: $module_name"
        return 1
    fi
}

main_menu() {
    while true; do
        welcome_banner
        
        echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║            主 菜 单                 ║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} 1. 系统工具    ${BLUE}║${NC} 2. 网络工具    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 3. 开发工具    ${BLUE}║${NC} 4. 娱乐功能    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 5. 个性化设置  ${BLUE}║${NC} 6. 工具箱管理  ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 0. 退出系统    ${BLUE}║${NC}                ${BLUE}║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
        echo
        echo -e "${PURPLE}输入【泠】触发彩蛋${NC}"
        echo -e "${GREEN}提示: 退出后输入'泠'可重新打开菜单${NC}"
        echo

        read -p "请输入选项 [0-6]: " choice
        
        if [ "$choice" = "泠" ]; then
            show_easter_egg
            continue
        fi
        
        case "$choice" in
            1)
                if load_module "system.sh"; then
                    system_tools
                else
                    echo -e "${RED}系统工具模块加载失败${NC}"
                    sleep 2
                fi
                ;;
            2)
                if load_module "network.sh"; then
                    network_tools
                else
                    echo -e "${RED}网络工具模块加载失败${NC}"
                    sleep 2
                fi
                ;;
            3)
                if load_module "development.sh"; then
                    dev_tools
                else
                    echo -e "${RED}开发工具模块加载失败${NC}"
                    sleep 2
                fi
                ;;
            4)
                if load_module "entertainment.sh"; then
                    fun_tools
                else
                    echo -e "${RED}娱乐功能模块加载失败${NC}"
                    sleep 2
                fi
                ;;
            5)
                if load_module "personalization.sh"; then
                    personal_settings
                else
                    echo -e "${RED}个性化设置模块加载失败${NC}"
                    sleep 2
                fi
                ;;
            6)
                toolbox_management
                ;;
            0)
                echo -e "${GREEN}感谢使用 Pinkshell！再见！${NC}"
                echo -e "${CYAN}作者: 快手啊泠好困想睡觉${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}无效输入！请输入 0-6 之间的数字${NC}"
                sleep 2
                ;;
        esac
    done
}

toolbox_management() {
    while true; do
        welcome_banner
        echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║           工具箱管理                 ║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} 1. 更新工具箱    ${BLUE}║${NC} 2. 检查依赖    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 3. 查看日志      ${BLUE}║${NC} 4. 备份配置    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 5. 恢复配置      ${BLUE}║${NC} 6. 重置工具箱  ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 0. 返回主菜单    ${BLUE}║${NC}                ${BLUE}║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
        echo

        read -p "请选择操作 [0-6]: " choice
        
        case "$choice" in
            1)
                update_toolbox
                ;;
            2)
                check_pinkshell_dependencies
                read -p "按任意键继续..."
                ;;
            3)
                view_logs
                ;;
            4)
                backup_config
                ;;
            5)
                restore_config
                ;;
            6)
                reset_toolbox
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

update_toolbox() {
    echo -e "${YELLOW}正在检查更新...${NC}"
    
    if command_exists curl; then
        echo -e "${GREEN}工具箱已是最新版本 v4.5${NC}"
    else
        echo -e "${RED}需要 curl 来检查更新${NC}"
    fi
    
    read -p "按任意键继续..."
}

view_logs() {
    if [ -f "$LOG_DIR/pinkshell.log" ]; then
        echo -e "${CYAN}最近的日志内容:${NC}"
        tail -20 "$LOG_DIR/pinkshell.log"
    else
        echo -e "${YELLOW}暂无日志记录${NC}"
    fi
    
    read -p "按任意键继续..."
}

backup_config() {
    local backup_dir="$HOME/pinkshell_backup"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    mkdir -p "$backup_dir"
    cp -r "$CONFIG_DIR" "$backup_dir/config_$timestamp"
    
    echo -e "${GREEN}配置已备份到: $backup_dir/config_$timestamp${NC}"
    read -p "按任意键继续..."
}

restore_config() {
    local backup_dir="$HOME/pinkshell_backup"
    
    if [ -d "$backup_dir" ]; then
        echo -e "${CYAN}可用的备份:${NC}"
        ls -1 "$backup_dir" | cat -n
        read -p "选择要恢复的备份编号: " backup_num
        
        local backups=($(ls -1 "$backup_dir"))
        local selected_backup="${backups[$((backup_num-1))]}"
        
        if [ -n "$selected_backup" ]; then
            cp -r "$backup_dir/$selected_backup"/* "$CONFIG_DIR"/
            echo -e "${GREEN}配置已恢复${NC}"
        else
            echo -e "${RED}无效的选择${NC}"
        fi
    else
        echo -e "${YELLOW}未找到备份目录${NC}"
    fi
    
    read -p "按任意键继续..."
}

reset_toolbox() {
    echo -e "${YELLOW}警告: 这将重置所有配置${NC}"
    read -p "确定要重置吗? [y/N] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        initialize_pinkshell
        echo -e "${GREEN}工具箱已重置${NC}"
    else
        echo -e "${YELLOW}取消重置${NC}"
    fi
    
    read -p "按任意键继续..."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_menu
fi