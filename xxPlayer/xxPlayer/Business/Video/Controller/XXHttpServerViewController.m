//
//  ViewController.m
//  xxPlayer
//
//  Created by xiao on 2018/3/19.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import "XXHttpServerViewController.h"
#import "AppDelegate.h"
#import "IPUtil.h"
#import "Masonry.h"

@interface XXHttpServerViewController ()

@end

@implementation XXHttpServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务器";
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    // 默认开启服务器
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app startServer];
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
    
    UILabel* label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"http://%@:8080",[IPUtil getIPv4]];
    [self.view addSubview:label];
    
    [switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(switchButton.mas_bottom).with.offset(30);
    }];
}

- (void)switchAction:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        // 启动服务器
        [app startServer];
        NSLog(@"开");
    } else {
        // 关闭服务器
        [app stopServer];
        NSLog(@"关");
    }
}

@end
