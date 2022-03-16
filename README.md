# 源脚本的配置

 下载

 git clone https://github.com/svenplus/linuxremote.git && cd linuxremote
 
 打包
 
 dpkg -b pack/ remoteapp.deb
 
 安装
 
 dpkg -i remoteapp.deb
 
 卸载
 
 dpkg -r remoteapp.deb
 
 ---
 
创建桌面快捷方式

复制 /usr/share/applications/remoteapp.destop 到桌面
右键点击允许启动

![image](https://user-images.githubusercontent.com/33768573/158308033-07237324-0803-409a-88af-1667a3f9bcea.png)

变成可执行的程序样式

![image](https://user-images.githubusercontent.com/33768573/158308133-b085c80a-4989-437a-8a2f-3c9ab07bf486.png)

---

# 软件的运行

运行软件前首先安装 freerdp2-x11 yad x11-utils

命令 ：apt-get install freerdp2-x11 yad x11-utils

---
双击运行

![image](https://user-images.githubusercontent.com/33768573/158308162-ff1b6994-681c-4c36-b8f6-5a8b0e04c01a.png)

---

