# FROM linuxserver/ffmpeg:amd64-latest
FROM registry.cn-hangzhou.aliyuncs.com/hanxiang/ffmpeg6.0-nodejs-linux-node20.18:01

# 拷贝 Chrome 安装包
COPY google-chrome-stable_current_amd64.deb /tmp/

# 安装 Chrome 浏览器并处理依赖 下载官方 .deb 安装包
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN apt-get update && \
    # apt-get install -y wget gnupg2 fonts-liberation libgtk-3-0 libvulkan1 xdg-utils && \
    (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt --fix-broken install -y) && \
    dpkg -i /tmp/google-chrome-stable_current_amd64.deb && \
    rm /tmp/google-chrome-stable_current_amd64.deb

