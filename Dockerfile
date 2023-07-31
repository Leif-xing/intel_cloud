# 使用 Ubuntu 22.04 镜像作为基础镜像
FROM ubuntu:22.04

# 设置工作目录为 ~/app
WORKDIR ~/app

# 修改 root 账号的密码为 root
RUN echo 'root:root' | chpasswd

# 执行 apt 更新并安装 net-tools 和 openssh-server
RUN apt update && \
    apt install -y curl net-tools openssh-server

# 将 SSH 端口更改为 2222，并允许 root 账号登录
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 重启 SSH 服务
RUN /etc/init.d/ssh restart

# 克隆代码库并给 ngrok.sh 添加执行权限
RUN apt install -y git && \
    git clone https://github.com/Leif-xing/script.git && \
    chmod +x script/ngrok.sh && \
    ./script/ngrok.sh

# 启动 ngrok 的 TCP 隧道
CMD ngrok start --all --config=script/ngrok.yml
