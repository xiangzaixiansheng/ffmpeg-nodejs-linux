FROM linuxserver/ffmpeg:amd64-version-8.0-cli

COPY dAppCluster /etc/dAppCluster


RUN tar zxf /etc/dAppCluster/node-v22.2.0-linux-x64.tar.gz -C /etc/dAppCluster/ && \
    mkdir -p /usr/local/nodejs && \
    mv /etc/dAppCluster/node-v22.2.0-linux-x64/* /usr/local/nodejs && \
    rm -rf /etc/dAppCluster/node-v22.2.0-linux-x64 /etc/dAppCluster/node-v22.2.0-linux-x64.tar.gz


RUN mkdir -p /usr/share/filebeat  && cd /usr/share && \
    tar -xzf /etc/dAppCluster/filebeat-8.13.0-linux-x86_64.tar.gz -C /usr/share/filebeat --strip-components=1 && \
    rm -f /etc/dAppCluster/filebeat-8.13.0-linux-x86_64.tar.gz && \
    chmod +x /usr/share/filebeat


ENV PATH=/usr/local/nodejs/bin:${PATH}

RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime


#定义时区参数
ENV TZ=Asia/Shanghai
#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

RUN npm config set registry https://registry.npmmirror.com && npm install -g pm2 cnpm;

# 安装python3
RUN apt-get update && apt-get install -y xvfb && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.12 -y && \
    apt-get install -y python3-pip curl wget vim && \
    apt-get install -y rsyslog rsyslog-kafka && \
    apt-get clean


# 安装puppeteer依赖
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2t64 \
    libpango-1.0-0 \
    libcairo2  && \
    apt install -y adb build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev fonts-noto-cjk  && \
    # 安装gl相关包
    apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*


# 安装gl相关包
RUN ln -s /usr/bin/python3 /usr/bin/python

# 安装puppeteer
RUN cnpm install -g puppeteer@24.28.0--unsafe-perm

# 预制ffcreator
RUN npm install -g ffcreator@7.5.8 --unsafe-perm;

# 拷贝 Chrome 安装包
COPY google-chrome-stable_current_amd64.deb /tmp/

# 安装 Chrome 浏览器并处理依赖 下载官方 .deb 安装包
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN apt-get update && \
    # apt-get install -y wget gnupg2 fonts-liberation libgtk-3-0 libvulkan1 xdg-utils && \
    (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt --fix-broken install -y) && \
    dpkg -i /tmp/google-chrome-stable_current_amd64.deb && \
    rm /tmp/google-chrome-stable_current_amd64.deb

