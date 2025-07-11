<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [python3.10镜像](#python310镜像)
  - [ffmpeg6.0 + nodejs16.17.1 + 内置ffcreator](#ffmpeg60--nodejs16171--内置ffcreator)
    - [一、镜像地址](#一镜像地址)
    - [二、修改问题：](#二修改问题)
    - [三、使用注意](#三使用注意)
    - [四、镜像dockerFile例子](#四镜像dockerfile例子)
      - [cp命令学习：](#cp命令学习)
        - [把ffcreator文件夹 拷贝到node\_modules下的ffcreator](#把ffcreator文件夹-拷贝到node_modules下的ffcreator)
    - [五、syslog的使用说明](#五syslog的使用说明)
    - [六、市区设置](#六市区设置)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## 镜像的地址:
registry.cn-hangzhou.aliyuncs.com/hanxiang/ffmpeg6.0-nodejs-linux-node20.18:01

```
这个主要增加了 chrome 浏览器 是正常版本的。
程序文件：/opt/google/chrome/
puppeteer的路径填写、可执行命令：/usr/bin/google-chrome-stable
```

registry.cn-hangzhou.aliyuncs.com/hanxiang/ffmpeg6.0-nodejs-linux-node20.18:02


# python3.10镜像
registry.cn-hangzhou.aliyuncs.com/mfe/ffmpeg6.0-nodejs-linux-node20.18:release-01
registry.cn-beijing.aliyuncs.com/mfe/ffmpeg6.0-nodejs-linux-node20.18:release-01



## ffmpeg6.0 + nodejs16.17.1 + 内置ffcreator

原因：在安装ffcreator的时候，gl和canvas包的时候会去请求外网的东西。需要挂梯子才能安装。

如果像网上其他教程说的,我这还是不可以。所以就制作一个基础镜像，内置了ffcreator

```
npm install canvas --canvas_binary_host_mirror=https://registry.npmmirror.com/-/binary/canvas/

npm install gl --gl_binary_host_mirror=https://registry.npmmirror.com/-/binary/gl

```



### 一、镜像地址

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux:v2-ffcreator

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

镜像说明：

chrome的地址：
/root/.cache/puppeteer/chrome/linux-130.0.6723.58/chrome-linux64/chrome





#### cp命令学习：

##### 把ffcreator文件夹 拷贝到node_modules下的ffcreator
cp -r /usr/local/nodejs/lib/node_modules/ffcreator ./node_modules



**把ffcreator文件夹下的node_modules内容 拷贝到node_modules下的**


cp -r /usr/local/nodejs/lib/node_modules/ffcreator/node_modules/* ./node_modules/


### 五、syslog的使用说明

```
$EscapeControlCharactersOnReceive off
ruleset( name="forwardRuleSet_logmix" ) {
    action(
        type="omfwd"
        Target="*****.cn"
        Port="514"
        Protocol="tcp"
        RebindInterval="5000"
        action.resumeRetryCount="-1"
        zipLevel="3"
        compression.mode="single"
        name="action_logmix"
        queue.type="linkedlist"
        queue.workerthreads="4"
        queue.filename="action_logmix"
        queue.size="1500000"
        queue.dequeuebatchsize="500"
        queue.maxdiskspace="1000M"
        queue.discardseverity="8"
        queue.maxfilesize="200M"
        queue.saveonshutdown="on"
        queue.HighWatermark="900000" #当内存队列达到这些元素时，开始回写磁盘。
        queue.LowWatermark="15000" #当内存队列小于这些元素时，停止回写磁盘。
        queue.DiscardMark="1200000" #超出亿后，会禁止新消息入队，丢弃消息。如果前一个被禁止，那么丢弃数据将无针对性,如果
        queue.TimeoutEnqueue="0" #超时3秒，TCP或local_socket方式下，预防资源夯住，引起崩溃。
    )
    stop
}
 
if ( $syslogfacility-text == 'local5') then {
    call forwardRuleSet_logmix
    stop
}

```


拷贝配置 并启动syslog的方法

```shell
#!/bin/bash
cp ./rsyslog.conf /etc/rsyslog.d/logger_rsyslog.conf

/sbin/rsyslogd &>/dev/null
# pm2 start ./build/index.js --name app --no-daemon
pm2 start ./exec/process.json --no-daemon

```


### 六、市区设置

#定义时区参数
ENV TZ=Asia/Shanghai

#设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone
