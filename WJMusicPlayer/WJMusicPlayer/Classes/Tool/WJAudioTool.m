//
//  WJAudioTool.m
//  WJMusicPlayer
//
//  Created by Kevin on 15/4/2.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "WJAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@interface WJAudioTool()

@property (nonatomic, strong) NSMutableDictionary *soundIDs;

@end

@implementation WJAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_musics;

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _musics = [NSMutableDictionary dictionary];
}

#pragma mark - 播放音乐
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName
{
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    // 2.判断播放器是否为nil
    if (player == nil) {
        // 2.0.获取资源的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        // 2.1.创建播放器对象
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.2.准备播放
        [player prepareToPlay];
        
        // 2.3.存入到字典中
        _musics[musicName] = player;
    }
    
    // 3.播放音乐
    [player play];
    
    // 4.返回播放器
    return player;
}

+ (void)pauseMusicWithName:(NSString *)musicName
{
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    // 2.如果有值
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)musicName
{
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    // 2.如果有值
    if (player) {
        [player stop];
        [_musics removeObjectForKey:musicName];
        player = nil;
    }
}


#pragma mark - 播放音效
+ (void)playSoundWithName:(NSString *)soundName
{
    // 1.从字典当中出去音效的ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    // 2.如果现在取出的值是0
    if (soundID == 0) {
        // 2.1.获取资源的URL
        NSURL *buyaoURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        // 2.2.给SoundID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(buyaoURL), &soundID);
        
        // 2.3.放入到字典中
        _soundIDs[soundName] = @(soundID);
    }
    
    // 3.播放音效
    AudioServicesPlayAlertSound(soundID);
}

+ (void)disposeSoundWithName:(NSString *)soundName
{
    // 1.从字典当中出去音效的ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    // 2.如果soundID有值,则销毁音效
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

@end
