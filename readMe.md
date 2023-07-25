1、ffmpeg6.0 + nodejs16.17.1 + linux

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux:v1

2、ffmpeg4.7 + nodejs16.17.1 + nvm + ubuntu

docker pull xiangzaidocker/ffmpeg4.7-nodejs-ubuntu-v1

编译命令

docker build --platform linux/x86_64 -t ffmpeg6.0-nodejs-linux .
