# FROM linuxserver/ffmpeg:amd64-latest
FROM registry.cn-hangzhou.aliyuncs.com/mfe/ffmpeg6.0-nodejs-linux-node20.18:release-01

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