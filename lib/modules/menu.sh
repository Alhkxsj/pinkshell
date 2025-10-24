#!/bin/bash
# Pinkshell 主菜单

# 加载统一启动器
if [ -f "$HOME/pinkshell/bin/pinkshell.sh" ]; then
    source "$HOME/pinkshell/bin/pinkshell.sh"
else
    echo -e "\033[1;31m错误: 找不到统一启动器\033[0m"
    echo -e "\033[1;33m请重新安装 Pinkshell\033[0m"
    exit 1
fi

# 模块加载函数
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

# 系统工具函数（如果模块加载失败时的备用函数）
system_tools_fallback() {
    echo -e "${YELLOW}系统工具模块加载失败，使用基础功能...${NC}"
    echo -e "${CYAN}基础系统信息:${NC}"
    
    # 显示基础系统信息
    echo -e "${GREEN}系统信息:${NC}"
    echo -e "设备: $(uname -npo 2>/dev/null || uname -s)"
    echo -e "内核: $(uname -r)"
    echo -e "存储: $(df -h / | awk 'NR==2 {print $4}') 可用"
    echo -e "内存: $(free -m 2>/dev/null | awk 'NR==2 {print $7}')MB 可用"
    
    echo -e "\n${CYAN}按任意键返回...${NC}"
    read -n 1 -s
}

# 网络工具函数（备用）
network_tools_fallback() {
    echo -e "${YELLOW}网络工具模块加载失败，使用基础功能...${NC}"
    
    echo -e "${GREEN}网络信息:${NC}"
    if command -v ip &>/dev/null; then
        ip addr show | grep inet | head -n 5
    else
        ifconfig 2>/dev/null | grep inet | head -n 5 || echo "无法获取网络信息"
    fi
    
    echo -e "\n${CYAN}按任意键返回...${NC}"
    read -n 1 -s
}

# 开发工具函数（备用）
dev_tools_fallback() {
    echo -e "${YELLOW}开发工具模块加载失败，使用基础功能...${NC}"
    
    echo -e "${GREEN}开发环境检查:${NC}"
    
    # 检查Python
    if command -v python &>/dev/null || command -v python3 &>/dev/null; then
        echo -e "Python: $(python --version 2>/dev/null || python3 --version 2>/dev/null)"
    else
        echo -e "Python: 未安装"
    fi
    
    # 检查Node.js
    if command -v node &>/dev/null; then
        echo -e "Node.js: $(node --version)"
    else
        echo -e "Node.js: 未安装"
    fi
    
    # 检查Git
    if command -v git &>/dev/null; then
        echo -e "Git: $(git --version)"
    else
        echo -e "Git: 未安装"
    fi
    
    echo -e "\n${CYAN}按任意键返回...${NC}"
    read -n 1 -s
}

# 娱乐功能函数（备用）
fun_tools_fallback() {
    echo -e "${YELLOW}娱乐功能模块加载失败，使用基础功能...${NC}"
    
    echo -e "${GREEN}娱乐功能:${NC}"
    echo -e "1. 猜数字游戏"
    echo -e "2. 显示笑话"
    echo -e "3. 计算器"
    read -p "请选择: " choice
    
    case $choice in
        1)
            # 猜数字游戏
            local number=$((RANDOM % 100 + 1))
            local attempts=0
            echo -e "我已经想了一个1-100之间的数字，猜猜是多少？"
            
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
            ;;
        2)
            # 显示笑话
            local jokes=(
                "为什么程序员喜欢黑暗模式？因为光会吸引bug！"
                "为什么程序员分不清万圣节和圣诞节？因为Oct 31 == Dec 25！"
                "程序员最浪漫的情话：'你是我生命中的唯一常量'"
            )
            local random_joke=${jokes[$RANDOM % ${#jokes[@]}]}
            echo -e "\n${YELLOW}${random_joke}${NC}"
            ;;
        3)
            # 简易计算器
            echo -e "${CYAN}简易计算器${NC}"
            read -p "请输入表达式 (如: 2 + 3): " expression
            if command -v bc &>/dev/null; then
                local result=$(echo "scale=2; $expression" | bc 2>/dev/null)
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}结果: $result${NC}"
                else
                    echo -e "${RED}计算错误！${NC}"
                fi
            else
                echo -e "${RED}需要安装 bc 计算器${NC}"
            fi
            ;;
        *)
            echo -e "${RED}无效选择！${NC}"
            ;;
    esac
    
    echo -e "\n${CYAN}按任意键返回...${NC}"
    read -n 1 -s
}

# 个性化设置函数（备用）
personal_settings_fallback() {
    echo -e "${YELLOW}个性化设置模块加载失败，使用基础功能...${NC}"
    
    echo -e "${GREEN}基础个性化设置:${NC}"
    echo -e "1. 更改欢迎语"
    echo -e "2. 查看当前配置"
    read -p "请选择: " choice
    
    case $choice in
        1)
            read -p "请输入新的欢迎语: " welcome_msg
            if [ -n "$welcome_msg" ]; then
                echo "WELCOME_MSG=\"$welcome_msg\"" >> "$CONFIG_DIR/config.conf"
                echo -e "${GREEN}欢迎语已更新！${NC}"
            fi
            ;;
        2)
            if [ -f "$CONFIG_DIR/config.conf" ]; then
                echo -e "${CYAN}当前配置:${NC}"
                cat "$CONFIG_DIR/config.conf"
            else
                echo -e "${YELLOW}暂无配置文件${NC}"
            fi
            ;;
        *)
            echo -e "${RED}无效选择！${NC}"
            ;;
    esac
    
    echo -e "\n${CYAN}按任意键返回...${NC}"
    read -n 1 -s
}

# 主菜单
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
        
        # 彩蛋触发
        if [ "$choice" = "泠" ]; then
            show_easter_egg
            continue
        fi
        
        case "$choice" in
            1)
                if load_module "system.sh"; then
                    system_tools
                else
                    system_tools_fallback
                fi
                ;;
            2)
                if load_module "network.sh"; then
                    network_tools
                else
                    network_tools_fallback
                fi
                ;;
            3)
                if load_module "development.sh"; then
                    dev_tools
                else
                    dev_tools_fallback
                fi
                ;;
            4)
                if load_module "entertainment.sh"; then
                    fun_tools
                else
                    fun_tools_fallback
                fi
                ;;
            5)
                if load_module "personalization.sh"; then
                    personal_settings
                else
                    personal_settings_fallback
                fi
                ;;
            6)
                toolbox_management
                ;;
            0)
                echo -e "${GREEN}感谢使用 Pinkshell！再见！${NC}"
                echo -e "${CYAN}作者: 快手啊泠好困想睡觉${NC}"
                echo -e "${BLUE}版本: v4.5 修复版${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}无效输入！请输入 0-6 之间的数字${NC}"
                sleep 2
                ;;
        esac
    done
}

# 工具箱管理功能
toolbox_management() {
    while true; do
        welcome_banner
        echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║           工具箱管理                 ║${NC}"
        echo -e "${BLUE}╠══════════════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} 1. 更新工具箱    ${BLUE}║${NC} 2. 检查依赖    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 3. 查看日志      ${BLUE}║${NC} 4. 备份配置    ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 5. 恢复配置      ${BLUE}║${NC} 6. 重置工具箱  ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 7. 系统信息      ${BLUE}║${NC} 0. 返回主菜单  ${BLUE}║${NC}"
        echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
        echo

        read -p "请选择操作 [0-7]: " choice
        
        case "$choice" in
            1)
                update_toolbox
                ;;
            2)
                check_pinkshell_dependencies
                echo -e "\n${CYAN}按任意键继续...${NC}"
                read -n 1 -s
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
            7)
                show_system_info
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

# 更新工具箱
update_toolbox() {
    echo -e "${YELLOW}正在检查更新...${NC}"
    
    if command_exists curl; then
        # 这里可以添加实际的更新逻辑
        local current_version="4.5"
        echo -e "${GREEN}当前版本: v${current_version}${NC}"
        echo -e "${CYAN}工具箱已是最新版本${NC}"
        
        # 检查工具更新
        echo -e "\n${YELLOW}检查系统工具更新...${NC}"
        pkg update
        echo -e "${GREEN}系统工具更新完成${NC}"
    else
        echo -e "${RED}需要 curl 来检查更新${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 查看日志
view_logs() {
    if [ -f "$LOG_DIR/pinkshell.log" ]; then
        echo -e "${CYAN}最近的日志内容:${NC}"
        echo -e "${YELLOW}══════════════════════════════════════${NC}"
        tail -20 "$LOG_DIR/pinkshell.log"
        echo -e "${YELLOW}══════════════════════════════════════${NC}"
        echo -e "\n${GREEN}完整日志文件: $LOG_DIR/pinkshell.log${NC}"
    else
        echo -e "${YELLOW}暂无日志记录${NC}"
        echo -e "${CYAN}日志文件: $LOG_DIR/pinkshell.log${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 备份配置
backup_config() {
    local backup_dir="$HOME/pinkshell_backup"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    mkdir -p "$backup_dir"
    
    if cp -r "$CONFIG_DIR" "$backup_dir/config_$timestamp"; then
        echo -e "${GREEN}配置已备份到: $backup_dir/config_$timestamp${NC}"
        echo -e "${CYAN}备份内容:${NC}"
        ls -la "$backup_dir/config_$timestamp/"
    else
        echo -e "${RED}备份失败！${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 恢复配置
restore_config() {
    local backup_dir="$HOME/pinkshell_backup"
    
    if [ -d "$backup_dir" ]; then
        echo -e "${CYAN}可用的备份:${NC}"
        local backups=($(ls -1 "$backup_dir" 2>/dev/null))
        
        if [ ${#backups[@]} -eq 0 ]; then
            echo -e "${YELLOW}未找到备份文件${NC}"
        else
            for i in "${!backups[@]}"; do
                echo "$((i+1)). ${backups[$i]}"
            done
            
            echo
            read -p "选择要恢复的备份编号: " backup_num
            
            if [[ "$backup_num" =~ ^[0-9]+$ ]] && [ "$backup_num" -ge 1 ] && [ "$backup_num" -le ${#backups[@]} ]; then
                local selected_backup="${backups[$((backup_num-1))]}"
                local backup_path="$backup_dir/$selected_backup"
                
                if [ -d "$backup_path" ]; then
                    # 备份当前配置
                    local current_backup="$backup_dir/current_backup_$(date +%Y%m%d_%H%M%S)"
                    cp -r "$CONFIG_DIR" "$current_backup"
                    
                    # 恢复配置
                    if cp -r "$backup_path"/* "$CONFIG_DIR"/ 2>/dev/null; then
                        echo -e "${GREEN}配置已从 $selected_backup 恢复${NC}"
                        echo -e "${YELLOW}原配置已备份到: $current_backup${NC}"
                    else
                        echo -e "${RED}恢复失败！${NC}"
                        # 恢复备份
                        cp -r "$current_backup"/* "$CONFIG_DIR"/
                        rm -rf "$current_backup"
                    fi
                else
                    echo -e "${RED}备份文件无效: $backup_path${NC}"
                fi
            else
                echo -e "${RED}无效的备份编号！${NC}"
            fi
        fi
    else
        echo -e "${YELLOW}未找到备份目录: $backup_dir${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 重置工具箱
reset_toolbox() {
    echo -e "${YELLOW}══════════════════════════════════════${NC}"
    echo -e "${RED}          警告: 重置工具箱${NC}"
    echo -e "${YELLOW}══════════════════════════════════════${NC}"
    echo -e "${YELLOW}这将删除所有个性化配置和设置！${NC}"
    echo -e "${YELLOW}包括:${NC}"
    echo -e "  • 所有配置文件"
    echo -e "  • 个性化设置"
    echo -e "  • 工具箱设置"
    echo -e "${YELLOW}══════════════════════════════════════${NC}"
    
    read -p "确定要重置吗? [y/N] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 创建备份
        local backup_dir="$HOME/pinkshell_backup"
        local reset_backup="$backup_dir/reset_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        cp -r "$CONFIG_DIR" "$reset_backup"
        
        # 重置配置
        rm -rf "$CONFIG_DIR"
        initialize_pinkshell
        
        echo -e "${GREEN}工具箱已重置为默认设置！${NC}"
        echo -e "${YELLOW}原配置已备份到: $reset_backup${NC}"
    else
        echo -e "${YELLOW}取消重置操作${NC}"
    fi
    
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 显示系统信息
show_system_info() {
    echo -e "${CYAN}══════════════════════════════════════${NC}"
    echo -e "${BLUE}            系统信息${NC}"
    echo -e "${CYAN}══════════════════════════════════════${NC}"
    
    # 使用核心模块的系统信息函数
    if command_exists get_system_info; then
        get_system_info
    else
        # 备用系统信息
        echo -e "${GREEN}设备信息:${NC}"
        echo -e "系统: $(uname -s)"
        echo -e "主机: $(uname -n)"
        echo -e "架构: $(uname -m)"
        echo -e "内核: $(uname -r)"
        
        echo -e "\n${GREEN}存储信息:${NC}"
        df -h / | awk 'NR==1 || NR==2'
        
        echo -e "\n${GREEN}内存信息:${NC}"
        if command_exists free; then
            free -h | awk 'NR==1 || NR==2'
        else
            echo "free 命令不可用"
        fi
        
        echo -e "\n${GREEN}Termux 信息:${NC}"
        if [ -f "$PREFIX/etc/termux/version" ]; then
            echo -e "版本: $(cat "$PREFIX/etc/termux/version")"
        else
            echo -e "版本: 未知"
        fi
    fi
    
    echo -e "${CYAN}══════════════════════════════════════${NC}"
    echo -e "\n${CYAN}按任意键继续...${NC}"
    read -n 1 -s
}

# 启动主菜单
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # 确保必要的目录存在
    mkdir -p "$CONFIG_DIR" "$LOG_DIR"
    
    # 启动主菜单
    main_menu
fi