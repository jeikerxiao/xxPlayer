# xxPlayer

功能：使用HttpServer 从电脑端上传视频到手机上，在手机的列表中进行播放。

# 工程使用

进入  xxPlayer 目录, Podfile同级：

```
cd xxPlayer
```

安装三方依赖

```
pod install
```

运行项目。

# 功能使用

进入视频页，点击右上角“+”号，进入 HttpServer 服务器界面。

在电脑端，输入 HttpServer 服务器界面显示的地址：

通过电脑访问手机网站，然后上传视频文件。

等上传完后，返回视频列表页，可看到视频出现在列表中，可以进行播放。

# 小记

info.plist

```xml
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```

