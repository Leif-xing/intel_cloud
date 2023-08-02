# Ubuntu 22.04 server

### 使用 Dockerfile 构建镜像并启动容器：
1. docker build -t ubuntu .
2. docker run -d -it --name ubuntu.server --hostname zidy --shm-size 1g ubuntu
3. docker attach ubuntu.server
4. cd script/ngrok
5. ./start.sh
