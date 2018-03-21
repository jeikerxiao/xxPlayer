//
//  XXVideoViewController.m
//  xxPlayer
//
//  Created by xiao on 2018/3/20.
//  Copyright © 2018年 jeikerxiao. All rights reserved.
//

#import "XXVideoViewController.h"
#import "XXSingleVideoViewController.h"
#import "XXHttpServerViewController.h"
#import "KYVedioPlayer.h"
#import "XXVideoCell.h"
#import "XXVideoUtil.h"
#import "XXFileUtil.h"


@interface XXVideoViewController ()<UITableViewDelegate, UITableViewDataSource,XXVideoCellDelegate,KYVedioPlayerDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataSource;

@end

@implementation XXVideoViewController {
    KYVedioPlayer* vedioPlayer;
    XXVideo *currentVideo;
    NSIndexPath *currentIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataSource = [self reloadDataSource];
    [self.tableView reloadData];
}

- (BOOL)prefersStatusBarHidden{
    if (vedioPlayer) {
        if (vedioPlayer.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (XXVideoCell *)currentCell{
    if (currentIndexPath==nil) {
        return nil;
    }
    XXVideoCell *currentCell = (XXVideoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    return currentCell;
}

/**
 * 显示 从全屏来当前的cell视频
 **/
- (void)showCellCurrentVedioPlayer{
    
    if (currentVideo != nil &&  currentIndexPath != nil) {
        
        XXVideoCell *currentCell = [self currentCell];
        [vedioPlayer removeFromSuperview];
        
        [UIView animateWithDuration:0.5f animations:^{
            vedioPlayer.transform = CGAffineTransformIdentity;
            vedioPlayer.frame = currentCell.vedioBg.bounds;
            vedioPlayer.playerLayer.frame =  vedioPlayer.bounds;
            [currentCell.vedioBg addSubview:vedioPlayer];
            [currentCell.vedioBg bringSubviewToFront:vedioPlayer];
            [vedioPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(vedioPlayer).with.offset(0);
                make.right.equalTo(vedioPlayer).with.offset(0);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(vedioPlayer).with.offset(0);
            }];
            [vedioPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(vedioPlayer).with.offset(0);
                make.right.equalTo(vedioPlayer).with.offset(0);
                make.height.mas_equalTo(40);
                make.top.equalTo(vedioPlayer).with.offset(0);
            }];
            [vedioPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(vedioPlayer.topView).with.offset(45);
                make.right.equalTo(vedioPlayer.topView).with.offset(-45);
                make.center.equalTo(vedioPlayer.topView);
                make.top.equalTo(vedioPlayer.topView).with.offset(0);
            }];
            [vedioPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(vedioPlayer).with.offset(5);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(30);
                make.top.equalTo(vedioPlayer).with.offset(5);
            }];
            [vedioPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(vedioPlayer);
                make.width.equalTo(vedioPlayer);
                make.height.equalTo(@30);
            }];
        }completion:^(BOOL finished) {
            vedioPlayer.isFullscreen = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            vedioPlayer.fullScreenBtn.selected = NO;
            
        }];
    }
}

#pragma  mark - 初始化方法
- (void)setUpView {
    self.view.backgroundColor = [UIColor whiteColor];
    // tableView
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[XXVideoCell class] forCellReuseIdentifier:[XXVideoCell cellReuseIdentifier]];
        tableView;
    });
    [self.view addSubview:self.tableView];
    // httpServer
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(httpServer)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)httpServer {
    NSLog(@"httpServer VC");
    
    XXHttpServerViewController *httpServerVC = [[XXHttpServerViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:httpServerVC animated:YES];
}

- (NSMutableArray *) reloadDataSource {
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *uploadDirPath = [docDir stringByAppendingPathComponent:@"upload"];
    NSArray *fileList = [[NSFileManager  defaultManager]  contentsOfDirectoryAtPath:uploadDirPath error:nil];

    NSLog(@"fileList: %@", fileList);
    NSMutableArray *arrVideo = [NSMutableArray array];
    for (NSString * pathStr in fileList) {
        NSLog(@"视频地址 :%@/%@",uploadDirPath,pathStr);
        XXVideo *xxVideo = [[XXVideo alloc] init];
        xxVideo.title = pathStr;
        xxVideo.image = @"http://img05.tooopen.com/images/20150613/tooopen_sy_130221399593.jpg";
        xxVideo.video = [NSString stringWithFormat:@"%@/%@", uploadDirPath, pathStr];
        [arrVideo addObject:xxVideo];
    }
    return arrVideo;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[XXVideoCell cellReuseIdentifier]];
    if (nil == cell) {
        cell = [[XXVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XXVideoCell cellReuseIdentifier]];
    }
    XXVideo *kYVideo  = self.dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.video = kYVideo;
    cell.mydelegate = self;
    cell.playBtn.tag = indexPath.row;
    
    if (vedioPlayer && vedioPlayer.superview) {
        if (indexPath.row == currentIndexPath.row) {
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];    //隐藏播放按钮
        } else {
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];  //显示播放按钮
        }
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
        if (![indexpaths containsObject:currentIndexPath] && currentIndexPath != nil) { //复用机制
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:vedioPlayer]) {
                vedioPlayer.hidden = NO;
            } else {
                vedioPlayer.hidden = YES;
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
        }else{
            if ([cell.vedioBg.subviews containsObject:vedioPlayer]) {  //当滑倒所属当前视频的时候自动播放
                [cell.vedioBg addSubview:vedioPlayer];
                [vedioPlayer play];
                vedioPlayer.hidden = NO;
            }
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > 0) {
        XXVideo *kYVideo  = self.dataSource[indexPath.row];
        return kYVideo.curCellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XXSingleVideoViewController *singleVideoVC = [[XXSingleVideoViewController alloc] init];
    XXVideo *kYVideo  = self.dataSource[indexPath.row];
    singleVideoVC.title = kYVideo.title;
    singleVideoVC.URLString = kYVideo.video;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:singleVideoVC animated:YES];
    
}

#pragma mark - KYNetworkVideoCellDelegate

-(void)networkVideoCellVedioBgTapGesture:(XXVideo *)video{
    
    XXSingleVideoViewController *singleVideoVC = [[XXSingleVideoViewController alloc] init];
    singleVideoVC.title = video.title;
    singleVideoVC.URLString = video.video;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:singleVideoVC animated:YES];
    
}

-(void)networkVideoCellOnClickVideoPlay:(XXVideo *)video withVideoPlayBtn:(UIButton *)videoPlayBtn;{
    
    [self closeCurrentCellVedioPlayer];
    
    currentVideo = video;
    currentIndexPath = [NSIndexPath indexPathForRow:videoPlayBtn.tag inSection:0];
    XXVideoCell *cell =nil;
    if ([UIDevice currentDevice].systemVersion.floatValue>=8||[UIDevice currentDevice].systemVersion.floatValue<7) {
        cell = (XXVideoCell *)videoPlayBtn.superview.superview;
    }else{//ios7系统 UITableViewCell上多了一个层级UITableViewCellScrollView
        cell = (XXVideoCell *)videoPlayBtn.superview.superview.subviews;
    }
    
    if (vedioPlayer) {
        [self releasePlayer];
        vedioPlayer = [[KYVedioPlayer alloc]initWithFrame:cell.vedioBg.bounds];
        vedioPlayer.delegate = self;
        vedioPlayer.closeBtnStyle = CloseBtnStyleClose;
        vedioPlayer.titleLabel.text = video.title;
        vedioPlayer.URLString = video.video;
    }else{
        
        vedioPlayer = [[KYVedioPlayer alloc]initWithFrame:cell.vedioBg.bounds];
        vedioPlayer.delegate = self;
        vedioPlayer.closeBtnStyle = CloseBtnStyleClose;
        vedioPlayer.titleLabel.text = video.title;
        vedioPlayer.URLString = video.video;
    }
    
    [cell.vedioBg addSubview:vedioPlayer];
    [cell.vedioBg bringSubviewToFront:vedioPlayer];
    [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
    [self.tableView reloadData];
    
    
}
/**
 * 关闭当前cell 中的 视频
 **/
- (void)closeCurrentCellVedioPlayer{
    
    if (currentVideo != nil &&  currentIndexPath != nil) {
        XXVideoCell *currentCell = [self currentCell];
        [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
        [vedioPlayer removeFromSuperview];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


#pragma mark - KYVedioPlayerDelegate 播放器委托方法
//点击播放暂停按钮代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    
    NSLog(@"[KYVedioPlayer] clickedPlayOrPauseButton ");
}
//点击关闭按钮代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer clickedCloseButton:(UIButton *)closeBtn{
    
    NSLog(@"[KYVedioPlayer] clickedCloseButton ");
    
    if (kyvedioPlayer.isFullscreen == YES) { //点击全屏模式下的关闭按钮
        self.navigationController.navigationBarHidden = NO;
        [self showCellCurrentVedioPlayer];
    }else{
        
        [self closeCurrentCellVedioPlayer];
    }
    
}
//点击分享按钮代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer onClickShareBtn:(UIButton *)closeBtn{
    NSLog(@"[KYVedioPlayer] onClickShareBtn ");
}
//点击全屏按钮代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    NSLog(@"[KYVedioPlayer] clickedFullScreenButton ");
    
    if (fullScreenBtn.isSelected) {
        // 全屏显示
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        kyvedioPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [kyvedioPlayer showFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft player:kyvedioPlayer withFatherView:self.view];
    }else{
        // 退出全屏
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        [self showCellCurrentVedioPlayer];
        
    }
}
//单击WMPlayer的代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
    NSLog(@"[KYVedioPlayer] singleTaped ");
}
//双击WMPlayer的代理方法
- (void)kyvedioPlayer:(KYVedioPlayer *)kyvedioPlayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    
    NSLog(@"[KYVedioPlayer] doubleTaped ");
}

///播放状态
//播放失败的代理方法
- (void)kyvedioPlayerFailedPlay:(KYVedioPlayer *)kyvedioPlayer playerStatus:(KYVedioPlayerState)state{
    NSLog(@"[KYVedioPlayer] kyvedioPlayerFailedPlay  播放失败");
}
//准备播放的代理方法
- (void)kyvedioPlayerReadyToPlay:(KYVedioPlayer *)kyvedioPlayer playerStatus:(KYVedioPlayerState)state{
    
    NSLog(@"[KYVedioPlayer] kyvedioPlayerReadyToPlay  准备播放");
}
//播放完毕的代理方法
- (void)kyplayerFinishedPlay:(KYVedioPlayer *)kyvedioPlayer{
    
    NSLog(@"[KYVedioPlayer] kyvedioPlayerReadyToPlay  播放完毕");
    [self closeCurrentCellVedioPlayer];
}

/**
 *  注销播放器
 **/
- (void)releasePlayer {
    [vedioPlayer resetKYVedioPlayer];
    vedioPlayer = nil;
}

- (void)dealloc {
    [self releasePlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"KYNetworkVideoCellPlayVC dealloc");
}

@end
