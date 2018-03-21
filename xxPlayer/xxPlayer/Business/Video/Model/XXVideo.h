//
//  XXVideo.h
//  xxPlayer
//
//  Created by xiao on 2018/3/20.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXVideo : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * video;

@property (nonatomic, strong) UIImage *picture;

/**
 *自定义cell的高度
 */
@property (nonatomic, assign) CGFloat curCellHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
