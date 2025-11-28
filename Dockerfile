FROM registry.cn-beijing.aliyuncs.com/hanxiang/ffmpeg-nodejs-linux:ffmpeg8.0-node20-release-01


# 安装python3
RUN apt-get update && apt-get install -y python3.12-venv && \
    apt-get clean