//
//  AppDelegate.m
//  xxPlayer
//
//  Created by xiao on 2018/3/19.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHttpServer.h"
#import "IPUtil.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化服务器
    [self initHttpServer];
    // 初始化通知
    [self initNotification];
    // 配置日志框架
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // 初始化界面
    [self initViewController];

    return YES;
}

- (void)initViewController {
    // 1.系统创建window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 2.初始化视图
    self.viewController = [[ViewController alloc] init];
    // 3.添加视图到根控制器
    self.window.rootViewController = self.viewController;
    // 4.设置为主窗口并显示出来
    [self.window makeKeyAndVisible];
}

- (void)initNotification {
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handlerPortSuccess:) name:@"HTTPServer_get_port_success" object:nil];
    [nc addObserver:self selector:@selector(handlerPortFail:) name:@"HTTPServer_get_port_fail" object:nil];
}

- (void)initHttpServer {
    // 初始化
    _httpServer = [[HTTPServer alloc] init];
    // 告诉服务器通过Bonjour广播它的存在。
    // 这允许Safari等浏览器自动发现我们的服务。
    [_httpServer setType:@"_http._tcp."];
    // 设置服务器监听端口，不设置，则使用随机的端口号
    [_httpServer setPort:8080];
    // 从服务器文件地址中发布文件 -> web/index.html
    NSString *docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"web"] stringByDeletingLastPathComponent];
    NSLog(@"Setting document root: %@", docRoot);
    [_httpServer setDocumentRoot:docRoot];
    [_httpServer setConnectionClass:[MyHttpServer class]];
}

// 启动服务器
- (void)startServer {
    NSError *error = nil;
    if(![_httpServer start:&error]){
        NSLog(@"Error starting HTTP Server: %@", error);
    }else {
        NSString* ip = [IPUtil getIPv4];
        NSLog(@"Server: http://%@:8080",ip);
    }
}

// 关闭服务器
- (void)stopServer {
    [_httpServer stop];
}

- (void)handlerPortSuccess:(NSNotification *)notification{
    NSDictionary* userInfo = notification.userInfo;
    NSNumber* port = [userInfo valueForKey:@"local_port"];
    NSLog(@"handlerPortSuccess----port:%d",port.unsignedShortValue);
}

- (void)handlerPortFail:(NSNotification *)notification{
    NSLog(@"handlerPortFail-----");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
