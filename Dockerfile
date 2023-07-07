FROM linuxserver/ffmpeg:amd64-latest

COPY dAppCluster /etc/dAppCluster

RUN tar zxf /etc/dAppCluster/node-v16.17.1-linux-x64.tar.gz -C /etc/dAppCluster/; \
    mkdir -p /usr/local/nodejs\
    && mv /etc/dAppCluster/node-v16.17.1-linux-x64/* /usr/local/nodejs


ENV PATH=/usr/local/nodejs/bin:${PATH}

RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

RUN npm install -g pm2;

RUN apt-get update && apt-get install -y xvfb