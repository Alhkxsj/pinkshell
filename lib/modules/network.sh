#!/data/data/com.termux/files/usr/bin/bash
# 网络工具模块

# 网络工具菜单
network_tools() {
  while true; do
    welcome_banner
    echo -e "${BLUE}========== 网络工具 ==========${NC}"
    echo -e "1. IP信息"
    echo -e "2. 网络测速"
    echo -e "3. 端口扫描"
    echo -e "4. 下载工具"
    echo -e "5. 网络诊断"
    echo -e "0. 返回主菜单\n"
    echo -e "${BLUE}==============================${NC}"

    read -p "请输入选项 : " choice
    case $choice in
      1)
        echo -e "${GREEN}IP地址信息:${NC}"
        if command -v curl &>/dev/null; then
          curl ipinfo.io | lolcat
        else
          ip addr show | grep inet | grep -v inet6 | lolcat
        fi
        read -p "按回车键返回..."
        ;;
      2)
        echo -e "${YELLOW}正在测试网络速度...${NC}"
        # 使用Termux支持的替代测速方法
        if command -v iperf3 &>/dev/null; then
          echo -e "${CYAN}使用iperf3测试网络速度...${NC}"
          echo -e "${YELLOW}正在连接测试服务器...${NC}"
          iperf3 -c speedtest.serverius.net -p 5002 -P 4 | lolcat
        elif command -v curl &>/dev/null; then
          echo -e "${CYAN}使用文件下载速度测试...${NC}"
          echo -e "${YELLOW}测试下载速度（通过Google）...${NC}"
          start_time=$(date +%s)
          download_size=$(curl -s -w '%{size_download}' -o /dev/null https://www.google.com)
          end_time=$(date +%s)
          time_elapsed=$((end_time - start_time))
          if [ $time_elapsed -eq 0 ]; then
              time_elapsed=1
          fi
          speed=$((download_size * 8 / time_elapsed / 1000))
          echo -e "${GREEN}下载速度: ${speed} kbps${NC}" | lolcat
        else
          echo -e "${RED}无法进行网络测速，请先安装curl${NC}"
        fi
        read -p "按回车键返回..."
        ;;
      3)
        read -p "请输入要扫描的IP或域名: " target
        if [ -z "$target" ]; then
          target="127.0.0.1"
        fi

        # 优先使用 nmap
        if command -v nmap &>/dev/null; then
          echo -e "${YELLOW}正在使用 nmap 扫描 $target ...${NC}"
          nmap -T4 $target | lolcat
        
        # 其次使用 ncat (nmap 的一部分)
        elif command -v ncat &>/dev/null; then
          echo -e "${YELLOW}正在使用 ncat 进行快速端口扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            timeout 1 ncat -zv $target $port 2>&1 | grep succeeded | lolcat
          done
        
        # 使用 Python 替代方案
        elif [ -f "$HOME/pinkshell/bin/nc" ]; then
          echo -e "${YELLOW}正在使用 Python 端口扫描器扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            echo "扫描端口 $port ..."
            $HOME/pinkshell/bin/nc $target $port <<< "QUIT" 2>/dev/null && echo "端口 $port 开放" | lolcat
          done
        
        # 最后尝试 busybox
        elif command -v busybox &>/dev/null; then
          echo -e "${YELLOW}正在使用 busybox 扫描 $target ...${NC}"
          for port in {20,21,22,23,25,53,80,110,143,443,465,587,993,995,1433,1521,3306,3389,5432,5900,8080}; do
            timeout 1 busybox nc -zv $target $port 2>&1 | grep succeeded | lolcat
          done
        
        else
          echo -e "${RED}未找到端口扫描工具，请安装 nmap${NC}"
        fi
        read -p "按回车键返回..."
        ;;
      4)
        read -p "请输入下载链接: " url
        if [ -z "$url" ]; then
          echo -e "${RED}下载链接不能为空！${NC}"
          sleep 1
          continue
        fi

        # 优先使用 aria2
        if command -v aria2c &>/dev/null; then
          echo -e "${YELLOW}正在使用aria2下载...${NC}"
          aria2c -x 16 $url
        
        # 其次使用 curl
        elif command -v curl &>/dev/null; then
          echo -e "${YELLOW}正在使用curl下载...${NC}"
          filename=$(basename "$url")
          curl -O $url
          echo -e "${GREEN}文件已下载: $filename${NC}"
        
        # 使用 wget
        elif command -v wget &>/dev/null; then
          echo -e "${YELLOW}正在使用wget下载...${NC}"
          wget $url
        
        else
          echo -e "${RED}未找到下载工具，请安装 aria2、curl 或 wget${NC}"
        fi
        read -p "按回车键返回..."
        ;;
      5)
        echo -e "${GREEN}网络诊断信息:${NC}"
        echo -e "${CYAN}网络连接状态:${NC}"
        echo -e "${YELLOW}正在测试与Google的连接...${NC}"
        
        # 优先使用 ncat
        if command -v ncat &>/dev/null; then
          ncat -zv google.com 80 2>&1 | lolcat
        # 其次使用 Python 替代方案
        elif [ -f "$HOME/pinkshell/bin/nc" ]; then
          $HOME/pinkshell/bin/nc google.com 80 <<< "HEAD / HTTP/1.1\nHost: google.com\n\n" | lolcat
        # 使用 busybox
        elif command -v busybox &>/dev/null; then
          busybox nc -zv google.com 80 2>&1 | lolcat
        else
          ping -c 4 google.com | lolcat
        fi
        
        echo -e "\n${CYAN}路由追踪:${NC}"
        if command -v traceroute &>/dev/null; then
          traceroute google.com | lolcat
        else
          echo -e "${YELLOW}正在安装traceroute...${NC}"
          pkg install traceroute -y
          if command -v traceroute &>/dev/null; then
            traceroute google.com | lolcat
          else
            echo -e "${RED}安装失败！请手动安装: pkg install traceroute${NC}"
          fi
        fi
        
        echo -e "\n${CYAN}DNS解析:${NC}"
        echo -e "${YELLOW}正在测试DNS解析...${NC}"
        nslookup google.com | lolcat
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