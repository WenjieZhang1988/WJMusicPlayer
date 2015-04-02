//
//  WJPlayingViewController.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "WJPlayingViewController.h"
#import "UIView+AdjustFrame.h"
#import "WJMusicTool.h"
#import "WJMusic.h"
#import "WJAudioTool.h"
#import "WJLrcView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WJPlayingViewController () <AVAudioPlayerDelegate>

// 歌曲的Label
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
// 歌手的Label
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
// 歌手的封面
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
// 音乐总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
// 拖拽按钮
@property (weak, nonatomic) IBOutlet UIButton *sliderButton;
// 拖拽按钮距离左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeftCon;
// 拖动时,显示时间的Label
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;
// 播放或者暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
// 歌词的View
@property (weak, nonatomic) IBOutlet WJLrcView *lrcView;


// 记录正在播放的音乐
@property (nonatomic, strong) WJMusic *playingMusic;

// 进度的定时器
@property (nonatomic, strong) NSTimer *progressTimer;

// 进度的定时器
@property (nonatomic, strong) CADisplayLink *lrcTimer;

// 播放器
@property (nonatomic, strong) AVAudioPlayer *player;

/**
 *  退出控制器
 */
- (IBAction)exit;
/**
 *  进度条背景的点击
 */
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender;
/**
 *  拖拽按钮的拖拽事件
 */
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender;

#pragma mark - 歌词或者图片按钮的点击
- (IBAction)lrcOrPicClick:(UIButton *)sender;
#pragma mark - 播放控制按钮的点击
/**
 *  播放或者暂停按钮的点击
 */
- (IBAction)playOrPauseClick;
/**
 *  上一首
 */
- (IBAction)previousClick;
/**
 *  下一首
 */
- (IBAction)nextClick;

@end

@implementation WJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给显示时间的Label一个圆角
    self.showTimeLabel.layer.cornerRadius = 5.0;
    self.showTimeLabel.layer.masksToBounds = YES;
}

#pragma mark - 对控制器的操作
#pragma mark 显示控制器
- (void)show
{
    // 0.判断播放歌曲是否发生改变
    if (self.playingMusic && self.playingMusic != [WJMusicTool playingMusic]) {
        [self stopPlayingMusic];
    }
    
    // 1.拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    // 2.将自身的view添加到window上
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    
    // 3.给self.view一个动画
    self.view.y = self.view.height;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        
        // 开始播放音乐,并且展示数据
        [self startPlayingMusic];
    }];
}

#pragma mark 退出控制器
- (IBAction)exit {
    // 1.拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    // 2.执行动画退出
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        
        // 移除定时器
        [self removeProgressTimer];
        [self removeLrcTimer];
    }];
}

#pragma mark - 对音乐播放的控制器
#pragma mark 播放音乐
- (void)startPlayingMusic
{
    // 1.拿到出正在播放的音乐
    WJMusic *playingMusic = [WJMusicTool playingMusic];
    if (playingMusic == self.playingMusic) {
        [self addProgressTimer];
        [self addLrcTimer];
        
        return;
    }
    self.playingMusic = playingMusic;
    
    // 2.设置界面设置数据
    // 2.1.设置基本界面的数据
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
    
    // 2.2.给歌词View,歌词的文件名称
    self.lrcView.lrcname = playingMusic.lrcname;
    
    // 3.播放歌曲
    self.player = [WJAudioTool playMusicWithName:playingMusic.filename];
    self.player.delegate = self;
    self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
    
    // 4.添加定时器
    [self addProgressTimer];
    [self addLrcTimer];
    
    // 5.改变按钮的状态
    self.playOrPauseButton.selected = NO;
    
    // 6.开启显示锁屏的信息
    [self updateLockMusicInfo];
}
#pragma mark 停止音乐
- (void)stopPlayingMusic
{
    // 1.清空界面的数据
    self.songLabel.text = nil;
    self.singerLabel.text = nil;
    self.totalTimeLabel.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    
    // 2.停止音乐播放
    [WJAudioTool stopMusicWithName:self.playingMusic.filename];
    
    // 3.移除定时器
    [self removeProgressTimer];
    [self removeLrcTimer];
}

#pragma mark - 私有方法
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger second = (NSInteger)time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}

#pragma mark - 对定时器的操作
#pragma mark 添加进度定时器
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    [self updateInfo];
}
#pragma mark 移除进度定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark 添加歌词定时器
- (void)addLrcTimer
{
    if (self.lrcView.hidden) return;
    [self updateLrctime];
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrctime)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
#pragma mark 移除歌词定时器
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 更新进度条的内容
#pragma mark 随着播放进度,更新进度条
- (void)updateInfo
{
    // 0.计算出来播放的比例
    CGFloat progressRatio = self.player.currentTime / self.player.duration;
    
    // 1.更新位置
    self.sliderLeftCon.constant = progressRatio * (self.view.width - self.sliderButton.width);
    
    // 2.更新文字
    NSString *currentTimeStr = [self stringWithTime:self.player.currentTime];
    [self.sliderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    
    // 3.更新锁屏界面的信息
    [self updateLockMusicInfo];
}

#pragma mark - 更新歌词界面的时间
- (void)updateLrctime
{
    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark 当进度条被点击时,会执行该方法
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender {
    // 1.获取用户点击的点
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.改变sliderButton距离左边的约束
    CGFloat changeX = point.x - self.sliderButton.width * 0.5;
    if (changeX > self.view.width - self.sliderButton.width - 1) {
        changeX = self.view.width - self.sliderButton.width - 1;
    } else if (changeX < 0) {
        changeX = 0;
    }
    self.sliderLeftCon.constant = changeX;
    
    // 3.改变当前播放的时间
    CGFloat progressRatio = self.sliderLeftCon.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    self.player.currentTime = currentTime;
    
    // 4.更新文字
    [self updateInfo];
}

#pragma mark 拖拽按钮,被拖动的时候会执行该方法
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender {
    // 1.用户拖拽的Point
    CGPoint point = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 2.改变sliderButton的位置
    if (self.sliderLeftCon.constant + point.x > self.view.width - self.sliderButton.width - 1) {
        self.sliderLeftCon.constant = self.view.width - self.sliderButton.width - 1;
    } else if (self.sliderLeftCon.constant + point.x < 0) {
        self.sliderLeftCon.constant = 0;
    } else {
        self.sliderLeftCon.constant += point.x;
    }
    
    // 3.获取拖拽进度的播放时间
    CGFloat progressRatio = self.sliderLeftCon.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    
    // 4.更新文字
    NSString *currentTimeStr = [self stringWithTime:currentTime];
    [self.sliderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    self.showTimeLabel.text = currentTimeStr;
    
    // 4.监听拖拽手势状态
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 4.1.移除定时器
        [self removeProgressTimer];
        
        // 4.2.让显示时间的Label取消隐藏
        self.showTimeLabel.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
        // 4.1.更新播放的时间
        self.player.currentTime = currentTime;
        
        // 4.2.添加定时器
        [self addProgressTimer];
        
        // 4.3.让显示时间的Label隐藏
        self.showTimeLabel.hidden = YES;
    }
}

#pragma mark - 确定歌词的View要不要显示
- (IBAction)lrcOrPicClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.lrcView.hidden = !self.lrcView.hidden;
    
    if (self.lrcView.hidden) {
        [self removeLrcTimer];
    } else {
        [self addLrcTimer];
    }
}

#pragma mark - 播放控制按钮的点击
#pragma mark 播放或者暂停按钮的点击
- (IBAction)playOrPauseClick {
    
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    
    if (self.player.playing) {
        [self.player pause];
        [self removeProgressTimer];
        [self removeLrcTimer];
    } else {
        [self.player play];
        [self addProgressTimer];
        [self addLrcTimer];
    }
}
#pragma mark 上一首
- (IBAction)previousClick {
    [WJMusicTool previousMusic];
    [self stopPlayingMusic];
    [self startPlayingMusic];
}
#pragma mark 下一首
- (IBAction)nextClick {
    [WJMusicTool nextMusic];
    [self stopPlayingMusic];
    [self startPlayingMusic];
}

#pragma mark - AVAudioPlayer的代理方法
/**
 *  当歌曲播放完成时,会调用该方法
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextClick];
    }
}
/**
 *  当歌曲播放被打断
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self playOrPauseClick];
}
/**
 *  当歌曲播放结束打断,继续播放
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [self playOrPauseClick];
}

#pragma mark - 显示锁屏的信息
- (void)updateLockMusicInfo
{
    // 1.获取当前播放中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.设置显示的信息
    NSMutableDictionary *infos = [NSMutableDictionary dictionary];
    infos[MPMediaItemPropertyAlbumTitle] = self.playingMusic.name;
    infos[MPMediaItemPropertyAlbumArtist] = self.playingMusic.singer;
    infos[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic.icon]];
    infos[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    infos[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    
    [center setNowPlayingInfo:infos];
    
    // 3.开始监听远程事件(触摸时间/传感器事件/远程事件),之后会让第一响应者相应时间
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 4.让播放控制器成为第一响应者
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 监听远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPauseClick];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextClick];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousClick];
            break;
        default:
            break;
    }
}

@end
