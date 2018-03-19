//
//  IPUtil.h
//  ZOOM
//
//  Created by xiao on 2018/3/16.
//  Copyright © 2018年 Weshape3D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPUtil : NSObject

+ (NSString *)getIPv4;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;

@end
