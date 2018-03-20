//
//  XXVideoCell.h
//  xxPlayer
//
//  Created by xiao on 2018/3/20.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXVideo.h"

@protocol XXVideoCellDelegate;

@protocol XXVideoCellDelegate <NSObject>

- (void)networkVideoCellVedioBgTapGesture:(XXVideo *)video;
- (void)networkVideoCellOnClickVideoPlay:(XXVideo *)video withVideoPlayBtn:(UIButton *)videoPlayBtn;

@end

@interface XXVideoCell : UITableViewCell

@property (nonatomic,weak) id<XXVideoCellDelegate>mydelegate;

+ (NSString *) cellReuseIdentifier;

@property (nonatomic, strong) UIImageView* vedioBg;
@property (nonatomic, strong) UIButton* playBtn;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic,strong) XXVideo* video;

@end
