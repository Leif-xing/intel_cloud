# 使用 Ubuntu 22.04 镜像作为基础镜像
FROM ubuntu:22.04

# 设置工作目录为 /root/server
WORKDIR /root/server

# 修改 root 账号的密码为 root
RUN echo 'root:root' | chpasswd

# 执行 apt 更新软件包
RUN apt update

# 安装依赖的软件包
RUN DEBIAN_FRONTEND=noninteractive apt install -y git curl net-tools openssh-server xfce4 xfce4-goodies

# 将 SSH 端口更改为 2222，并允许 root 账号登录，配置 XRDP, 修改默认端口
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    touch ~/.xsessionrc && \
    echo xfce4-session > ~/.xsession && \
    echo exec startxfce4 >> /etc/xrdp/xrdp.ini && \
    sed -i 's/port=3389/port=13388/' /etc/xrdp/xrdp.ini

# 重启 SSH 和 XRDP 服务
RUN /etc/init.d/ssh restart && service xrdp restart

# 克隆代码库并给 ngrok.sh 添加执行权限
WORKDIR /root/server/script
RUN git clone https://github.com/Leif-xing/script.git && \
    chmod +x ngrok.sh && \
    ./script/ngrok.sh

# 启动 ngrok 的 TCP 隧道
CMD /bin/bash
