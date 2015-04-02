//
//  WJMusicTool.h
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  音乐工具类

#import <Foundation/Foundation.h>
@class WJMusic;

@interface WJMusicTool : NSObject

/**
 *  返回所有的数据
 *
 *  @return 所有的数据
 */
+ (NSArray *)musics;

/**
 *  返回当前正在播放的音乐
 *
 *  @return 正在的播放的音乐
 */
+ (WJMusic *)playingMusic;

/**
 *  设置正在播放的音乐
 */
+ (void)setPlayingMusic:(WJMusic *)playingMusic;

/**
 *  下一首歌曲
 *
 *  @return  下一首
 */
+ (WJMusic *)nextMusic;

/**
 *  上一首歌曲
 *
 *  @return  上一首
 */
+ (WJMusic *)previousMusic;

@end
