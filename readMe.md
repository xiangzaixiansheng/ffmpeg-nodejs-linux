1、ffmpeg6.0 + nodejs16.17.1 + linux

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux:v1

2、ffmpeg4.7 + nodejs16.17.1 + nvm + ubuntu

docker pull xiangzaidocker/ffmpeg4.7-nodejs-ubuntu-v1

3、ubuntu、ffmpeg6.0、nodejsv16.17.1、ffcreator@7.2.2、python3.10

预制ffcreator位置 /usr/local/nodejs/lib/node_modules/ffcreator

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux:v2-ffcreator

编译命令

docker build --platform linux/x86_64 -t ffmpeg6.0-nodejs-linux .
