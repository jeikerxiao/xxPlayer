//
//  AppDelegate.h
//  xxPlayer
//
//  Created by xiao on 2018/3/19.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class HTTPServer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    HTTPServer *httpServer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end

