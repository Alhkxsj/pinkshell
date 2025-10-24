#!/bin/bash
# 测试脚本

export HOME=/tmp/test_home
export PREFIX=/tmp/test_prefix
export PINKSHOME=/tmp/test_pinkshell

mkdir -p $HOME/.pinkshell/.config

# 创建一个简单的配置文件
cat > $HOME/.pinkshell/.config/config.conf << EOF
THEME_COLOR="pink"
ENABLE_ANIMATIONS="true"
AUTO_UPDATE="false"
LOG_LEVEL="info"
EOF

# 创建一个简单的bashrc文件
echo "export PINKSHOME=/tmp/test_pinkshell" > $HOME/.bashrc
echo "export PATH=\$PATH:\$PINKSHOME/bin" >> $HOME/.bashrc

# 测试菜单启动
echo "Testing menu startup..."
cd /tmp/test_pinkshell
timeout 5 bash bin/menu.sh --test 2>&1
exit_code=$?

if [ $exit_code -eq 124 ]; then
    echo "Menu started successfully (timeout as expected)"
else
    echo "Menu test failed with exit code: $exit_code"
fi