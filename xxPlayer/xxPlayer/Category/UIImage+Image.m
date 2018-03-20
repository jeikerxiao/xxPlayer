//
//  UIImage+Image.m
//  JDL
//
//  Created by xiao on 2018/3/19.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+(UIImage *)imageNameWithOriginMode:(NSString *)imageName{
    UIImage *image =[UIImage imageNamed:imageName];
    image =[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
@end
