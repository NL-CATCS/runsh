#!/bin/bash

# 更新系统并安装依赖
sudo apt update
sudo apt install -y supervisor net-tools

# 关闭防火墙
ufw disable

# 创建目录结构
mkdir -p /root/log

# 下载文件
wget -P /root https://github.com/NL-CATCS/runsh/raw/refs/heads/main/semrush
chmod 777 /root/semrush

# 配置Supervisor
cat > /etc/supervisor/conf.d/semrush.conf <<EOF
[program:semrush]
directory=/root
command=/root/semrush -port 80
autostart=true
autorestart=true
user=root
stderr_logfile=/root/log/semrush.err.log
stdout_logfile=/root/log/semrush.out.log
startsecs=2
EOF

# 启动服务
systemctl restart supervisor
supervisorctl update
supervisorctl restart semrush

# 验证状态
supervisorctl status
netstat -tunlp

echo "所有操作已完成。"
