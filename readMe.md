<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ffmpeg6.0 + nodejs16.17.1 + 内置ffcreator](#ffmpeg60--nodejs16171--%E5%86%85%E7%BD%AEffcreator)
  - [一、镜像地址](#%E4%B8%80%E9%95%9C%E5%83%8F%E5%9C%B0%E5%9D%80)
  - [二、修改问题：](#%E4%BA%8C%E4%BF%AE%E6%94%B9%E9%97%AE%E9%A2%98)
  - [三、使用注意](#%E4%B8%89%E4%BD%BF%E7%94%A8%E6%B3%A8%E6%84%8F)
  - [四、镜像dockerFile例子](#%E5%9B%9B%E9%95%9C%E5%83%8Fdockerfile%E4%BE%8B%E5%AD%90)
    - [cp命令学习：](#cp%E5%91%BD%E4%BB%A4%E5%AD%A6%E4%B9%A0)
      - [把ffcreator文件夹 拷贝到node_modules下的ffcreator](#%E6%8A%8Affcreator%E6%96%87%E4%BB%B6%E5%A4%B9-%E6%8B%B7%E8%B4%9D%E5%88%B0node_modules%E4%B8%8B%E7%9A%84ffcreator)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## ffmpeg6.0 + nodejs16.17.1 + 内置ffcreator

原因：在安装ffcreator的时候，gl和canvas包的时候会去请求外网的东西。需要挂梯子才能安装。

如果像网上其他教程说的,我这还是不可以。所以就制作一个基础镜像，内置了ffcreator

```
npm install canvas --canvas_binary_host_mirror=https://registry.npmmirror.com/-/binary/canvas/

npm install gl --gl_binary_host_mirror=https://registry.npmmirror.com/-/binary/gl

```



### 一、镜像地址

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux-v1:ffcreatorv1

ubuntu、ffmpeg6.0、nodejsv16.17.1、ffcreator@7.2.2、python3.10



ffcreator的安装位置

/usr/local/nodejs/lib/node_modules/ffcreator

### 二、修改问题：

1、修复时区问题
2、预制nodejs相关编译包 ffcreator等

3、安装python3.10



### 三、使用注意

ffcreator安装地址
/usr/local/nodejs/lib/node_modules/ffcreator



在项目中安装 ffcreator
npm install /usr/local/nodejs/lib/node_modules/ffcreator

**注意：项目中的package.json中ffcreator需要提前去除**
sed '/ffcreator/d' package.json > package2.json && mv package2.json package.json



### 四、镜像dockerFile例子

```dockerfile
FROM xiangzaidocker/ffmpeg6.0-nodejs-linux-v1:ffcreatorv1

COPY . /home/ffcreator
WORKDIR /home/ffcreator

RUN npm config set registry https://registry.npmmirror.com/

# 去除package.json里的内容
RUN sed '/ffcreator/d' package.json > package2.json && mv package2.json package.json


RUN npm_config_tarball=/home/ffcreator/node-v16.17.1-headers.tar.gz npm install && \
    npm install fluent-ffmpeg https-proxy-agent chalk request ffmpeg-probe && \
    npm install /usr/local/nodejs/lib/node_modules/ffcreator

ENV PORT=80

ENTRYPOINT NODE_ENV=prod pm2 start process.json --no-daemon
```

pm2启动的json。因为没有屏幕，所以使用Xvfb启动项目。

```json
{
  "apps" : [{
    "name"        : "ffcreator",
    "script"      : "./build/server.js",
    "env": {
      "DISPLAY": ":99",
      "NODE_ENV": "prod",
      "PORT": 80
    },
    "instances": 4,
    "instance_var": "INSTANCE_ID",
    "exec_mode": "cluster",
    "log_date_format": "YYYY-MM-DD HH:mm:ss",
    "error_file": "./logs/accesslogs/ffcreator-center-error.log",
     "out_file": "./logs/accesslogs/ffcreator-center-out.log"
  },
    {
      "name"        : "Xvfb",
      "interpreter" : "none",
      "script"      : "Xvfb",
      "args"        : ":99 -ac -screen 0 1280x1024x24"
    }]
}
```





#### cp命令学习：

##### 把ffcreator文件夹 拷贝到node_modules下的ffcreator
cp -r /usr/local/nodejs/lib/node_modules/ffcreator ./node_modules



**把ffcreator文件夹下的node_modules内容 拷贝到node_modules下的**


cp -r /usr/local/nodejs/lib/node_modules/ffcreator/node_modules/* ./node_modules/
