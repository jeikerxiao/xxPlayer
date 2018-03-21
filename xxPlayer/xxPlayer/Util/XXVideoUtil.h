//
//  XXVideoUtil.h
//  xxPlayer
//
//  Created by xiao on 2018/3/21.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXVideoUtil : NSObject

+ (UIImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
