FROM linuxserver/ffmpeg:amd64-latest

COPY dAppCluster /etc/dAppCluster

RUN tar zxf /etc/dAppCluster/node-v16.17.1-linux-x64.tar.gz -C /etc/dAppCluster/; \
    mkdir -p /usr/local/nodejs\
    && mv /etc/dAppCluster/node-v16.17.1-linux-x64/* /usr/local/nodejs


ENV PATH=/usr/local/nodejs/bin:${PATH}

RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

RUN npm install -g pm2;

# 安装python3
RUN apt-get update && apt-get install -y xvfb && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.10
# 安装gl相关包
RUN ln -s /usr/bin/python3 /usr/bin/python && apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config

# 预制ffcreator
RUN npm -g config set user root && \
    npm install -g ffcreator@7.2.2 --unsafe-perm;