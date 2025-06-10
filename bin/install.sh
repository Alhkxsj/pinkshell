#!/bin/bash
# 快手啊泠好困想睡觉 定制安装器

# 创建目录结构
mkdir -p ~/.pinkshell/{bin,lib,.config}

# 写入基础配置
cat >~/.pinkshell/.config/config.conf <<EOF
# 用户配置
USER_NAME="快手啊泠好困想睡觉"
THEME_COLOR="purple"
EOF

# 复制主程序
curl -o ~/.pinkshell/bin/menu.sh https://example.com/menu.sh
chmod +x ~/.pinkshell/bin/menu.sh

# 添加环境变量
echo 'export PATH="$PATH:$HOME/.pinkshell/bin"' >>~/.bashrc
source ~/.bashrc

echo -e "${GREEN}安装完成！输入 ${YELLOW}menu.sh ${GREEN}启动${NC}"
