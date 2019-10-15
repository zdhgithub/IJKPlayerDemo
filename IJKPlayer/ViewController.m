//
//  ViewController.m
//  IJKPlayer
//
//  Created by dh on 2019/10/14.
//  Copyright © 2019 dh. All rights reserved.
//

#import "ViewController.h"
//#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface ViewController ()
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//1. 根据当前环境设置日志信息
//1.1如果是Debug状态的
#ifdef DEBUG
//  设置报告日志
    [IJKFFMoviePlayerController setLogReport:YES];
//  设置日志的级别为Debug
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_VERBOSE];//k_IJK_LOG_VERBOSE k_IJK_LOG_DEBUG
//1.2否则(如果不是debug状态的)
#else
//  设置不报告日志
    [IJKFFMoviePlayerController setLogReport:NO];
//  设置日志级别为信息
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
//    /// 香港电影频道
//    NSURL *playerURL = [NSURL URLWithString:@"http://aldirect.hls.huya.com/huyalive/29106097-2689453724-11551115788685410304-2847687506-10057-A-1525422901-1_1200.m3u8"];
//    IJKFFMoviePlayerController *playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:playerURL withOptions:nil];
//    [playerVC prepareToPlay];
//    playerVC.view.frame = CGRectMake(30, 20, [UIScreen mainScreen].bounds.size.width * 2 / 3, [UIScreen mainScreen].bounds.size.height * 2 / 3);
//    playerVC.view.backgroundColor = [UIColor grayColor];
//    [self.view insertSubview:playerVC.view atIndex:1];

// 2. 检查版本是否匹配
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
// 3.  创建IJKFFMoviePlayerController
// 3.1 默认选项配置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
// 3.2 创建播放控制器
    NSString *str = @"http://aldirect.hls.huya.com/huyalive/29106097-2689453724-11551115788685410304-2847687506-10057-A-1525422901-1_1200.m3u8";
//    NSString *str = @"https://url.cn/5WN3YuI";
//    NSString *str = @"http://pull.ypkbvip.com/live/8b66f17832d14f1fa7803abed5abf692_480.flv";
//    NSString *str = @"rtmp://liveplay.ezttx.cn/yueman/1947447?txSecret=7b2d050d67d6ce1178a99e80b060bdc1&txTime=5da539d1";
    IJKFFMoviePlayerController *playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURLString:str withOptions: options];

    playerVC.shouldShowHudView = true;
    
//4. 屏幕适配
// 4.1 设置播放视频视图的frame与控制器的View的bounds一致
    playerVC.view.frame = self.view.bounds;
// 4.2 设置适配横竖屏(设置四边固定,长宽灵活)
    playerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//  4.3 设置播放视图的缩放模式
    playerVC.scalingMode = IJKMPMovieScalingModeAspectFit;
//  4.4 设置自动播放
    playerVC.shouldAutoplay = YES;
//  4.5 自动更新子视图的大小
    self.view.autoresizesSubviews = YES;
//  4.6 添加播放视图到控制器的View
//    [self.view insertSubview:playerVC.view atIndex:1];
    [self.view addSubview:playerVC.view];
    
    self.player = playerVC;
   
}

#pragma mark - 视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//  当试图即将展示的时候开始播放
    [self.player prepareToPlay];
    
    //  1. 添加播放状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
}
#pragma mark - 视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//  关闭播放
    [self.player shutdown];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
}

- (void) playbackStateDidChange:(NSNotification *) notification {
    
//    NSLog(@"%@",notification);
//    IJKMPMoviePlaybackStateStopped,        停止
//    IJKMPMoviePlaybackStatePlaying,        正在播放
//    IJKMPMoviePlaybackStatePaused,         暂停
//    IJKMPMoviePlaybackStateInterrupted,    打断
//    IJKMPMoviePlaybackStateSeekingForward, 快进
//    IJKMPMoviePlaybackStateSeekingBackward 快退
    
    
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"停止");
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"打断");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"快进");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            NSLog(@"快退");
            break;
        default:
            break;
    }
}
@end
