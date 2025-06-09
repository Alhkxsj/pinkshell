#!/bin/bash
# 快手啊泠好困想睡觉 定制安装器

# 创建目录结构
mkdir -p ~/pinkshell/{bin,lib}
mkdir -p ~/.pinkshell/.config

# 写入基础配置
cat > ~/.pinkshell/.config/config.conf <<EOF
# 用户配置
USER_NAME="快手啊泠好困想睡觉"
THEME_COLOR="purple"
SHOW_ANIMATION=true
AUTHOR_SIGNATURE="Customized for 快手啊泠好困想睡觉"
EOF

# 添加环境变量
echo 'export PATH="$PATH:$HOME/pinkshell/bin"' >> ~/.bashrc
echo 'source ~/pinkshell/lib/termux_utils.sh' >> ~/.bashrc
source ~/.bashrc

# 设置别名
if ! grep -q "alias 泠" ~/.bashrc; then
    echo "alias 泠='bash \$HOME/pinkshell/bin/menu.sh'" >> ~/.bashrc
fi

if ! grep -q "alias 更新" ~/.bashrc; then
    echo "alias 更新='pkg update && pkg upgrade'" >> ~/.bashrc
fi

if ! grep -q "alias 清理" ~/.bashrc; then
    echo "alias 清理='pkg clean'" >> ~/.bashrc
fi

if ! grep -q "alias 存储" ~/.bashrc; then
    echo "alias 存储='df -h'" >> ~/.bashrc
fi

echo -e "\033[1;32m"
echo "██████╗ ██╗   ██╗███████╗"
echo " ██╔═══██╗██║   ██║██╔════╝"
echo " ██║   ██║██║   ██║█████╗  "
echo " ██║▄▄ ██║██║   ██║██╔══╝  "
echo " ╚██████╔╝╚██████╔╝███████╗"
echo "  ╚══▀▀═╝  ╚═════╝ ╚══════╝"
echo -e "\033[0m"

echo -e "\033[1;35m[安装完成] 专属工具箱已配置完毕！\033[0m"
echo -e "\033[1;36m使用以下命令启动:"
echo -e "  1. 输入 '泠' 启动菜单"
echo -e "  2. 输入 'menu.sh' 启动菜单"
echo -e "  3. 重启Termux会自动启动菜单\033[0m"