

1、ffmpeg6.0 + nodejs16.17.1 + 内置ffcreator

docker pull xiangzaidocker/ffmpeg6.0-nodejs-linux-v1:ffcreatorv1


修改：
1、修复时区问题
2、预制nodejs相关编译包 ffcreator包等

ffcreator安装地址
/usr/local/nodejs/lib/node_modules/ffcreator



在项目中安装 ffcreator
npm install /usr/local/nodejs/lib/node_modules/ffcreator

**注意：项目中的package.json中ffcreator需要提前去除**
sed '/ffcreator/d' package.json > package2.json && mv package2.json package.json



cp命令学习：

##### 把ffcreator文件夹 拷贝到node_modules下的ffcreator
cp -r /usr/local/nodejs/lib/node_modules/ffcreator ./node_modules



**把ffcreator文件夹下的node_modules内容 拷贝到node_modules下的**


cp -r /usr/local/nodejs/lib/node_modules/ffcreator/node_modules/* ./node_modules/
