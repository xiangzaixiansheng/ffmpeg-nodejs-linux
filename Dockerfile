# FROM linuxserver/ffmpeg:amd64-latest
FROM linuxserver/ffmpeg:6.0-cli-ls93

COPY dAppCluster /etc/dAppCluster

RUN tar zxf /etc/dAppCluster/node-v20.18.0-linux-x64.tar.gz -C /etc/dAppCluster/; \
    mkdir -p /usr/local/nodejs\
    && mv /etc/dAppCluster/node-v20.18.0-linux-x64/* /usr/local/nodejs

RUN mkdir -p /usr/share/filebeat  && cd /usr/share && \
    tar -xzf /etc/dAppCluster/filebeat-8.13.0-linux-x86_64.tar.gz -C /usr/share/filebeat --strip-components=1 && \
    rm -f /etc/dAppCluster/filebeat-8.13.0-linux-x86_64.tar.gz && \
    chmod +x /usr/share/filebeat

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
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# 安装gl相关包
RUN ln -s /usr/bin/python3 /usr/bin/python && apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config

# 安装puppeteer
RUN cnpm install -g puppeteer@23.6.0 --unsafe-perm

# 预制ffcreator
RUN npm install -g ffcreator@7.5.8 --unsafe-perm;


# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装 Python 3.11
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-dev python3.11-distutils && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --set python3 /usr/bin/python3.11 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# 设置Android SDK环境变量
ENV ANDROID_HOME=/usr/local/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin


# 安装系统依赖、Android SDK和Python依赖
RUN apt-get install -y --no-install-recommends \
    adb \
    wget \
    unzip \
    openjdk-11-jdk \
    build-essential \
    cmake \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/* \

# 下载和安装Android SDK命令行工具
RUN mkdir -p $ANDROID_HOME && cd $ANDROID_HOME && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O sdk.zip && \
    unzip sdk.zip && \
    rm sdk.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true && \
    cd cmdline-tools/latest/bin && \
    ./sdkmanager --update && \
    yes | ./sdkmanager --licenses && \
    ./sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"