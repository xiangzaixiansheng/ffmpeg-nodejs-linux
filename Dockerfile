# FROM linuxserver/ffmpeg:amd64-latest
FROM linuxserver/ffmpeg:6.0-cli-ls93

COPY dAppCluster /etc/dAppCluster

RUN tar zxf /etc/dAppCluster/node-v18.20.4-linux-x64.tar.gz -C /etc/dAppCluster/; \
    mkdir -p /usr/local/nodejs\
    && mv /etc/dAppCluster/node-v18.20.4-linux-x64/* /usr/local/nodejs


ENV PATH=/usr/local/nodejs/bin:${PATH}

RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

RUN npm config set registry https://registry.npmmirror.com && npm install -g pm2 cnpm;

# 安装python3
RUN apt-get update && apt-get install -y xvfb && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.10 -y && \
    apt-get install -y python3-pip curl wget vim && \
    apt-get install -y rsyslog rsyslog-kafka && \
    apt-get clean


# 安装gl相关包
RUN ln -s /usr/bin/python3 /usr/bin/python && apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config

# 安装puppeteer
RUN cnpm install -g puppeteer@23.6.0 --unsafe-perm

# 预制ffcreator
RUN npm install -g ffcreator@7.5.8 --unsafe-perm;