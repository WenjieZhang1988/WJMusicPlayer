//
//  WJAudioTool.h
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  播放器工具类

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WJAudioTool : NSObject

/**
 *  播放音乐
 *
 *  @param musicName 音乐名称
 */
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;

+ (void)pauseMusicWithName:(NSString *)musicName;

+ (void)stopMusicWithName:(NSString *)musicName;

/**
 *  播放音效
 *
 *  @param soundName 音效名称
 */
+ (void)playSoundWithName:(NSString *)soundName;

/**
 *  销毁音效
 *
 *  @param soundName 音效名称
 */
+ (void)disposeSoundWithName:(NSString *)soundName;

@end
