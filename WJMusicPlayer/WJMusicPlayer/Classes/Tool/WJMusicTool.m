//
//  WJMusicTool.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "WJMusicTool.h"
#import "WJMusic.h"
#import "MJExtension.h"

@implementation WJMusicTool

static NSArray *_musics;
static WJMusic *_playingMusic;

+ (void)initialize
{
    _musics = [WJMusic objectArrayWithFilename:@"Musics.plist"];
}

/**
 *  返回所有的数据
 *
 *  @return 所有的数据
 */
+ (NSArray *)musics
{
    return _musics;
}

/**
 *  返回当前正在播放的音乐
 *
 *  @return 正在的播放的音乐
 */
+ (WJMusic *)playingMusic
{
    return _playingMusic;
}

/**
 *  设置正在播放的音乐
 */
+ (void)setPlayingMusic:(WJMusic *)playingMusic
{
    assert(playingMusic);
    _playingMusic = playingMusic;
}

/**
 *  下一首歌曲
 *
 *  @return  下一首
 */
+ (WJMusic *)nextMusic
{
    // 1.获取当前播放音乐的索引
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首音乐
    // 2.1.下标值加1
    currentIndex++;
    
    // 2.2.判断是否越界
    if (currentIndex > _musics.count - 1) {
        currentIndex = 0;
    }
    
    // 2.3.取出下一首的歌曲
    WJMusic *nextMusic = _musics[currentIndex];
    
    // 3.设置正在播放的音乐是下一首
    _playingMusic = nextMusic;
    
    return nextMusic;
}

/**
 *  上一首歌曲
 *
 *  @return  上一首
 */
+ (WJMusic *)previousMusic
{
    // 1.获取当前播放音乐的索引
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取上一首音乐
    // 2.1.下标值减1
    currentIndex--;
    
    // 2.2.判断是否越界
    if (currentIndex < 0) {
        currentIndex = _musics.count - 1;
    }
    
    // 2.3.取出上一首的歌曲
    WJMusic *previousMusic = _musics[currentIndex];
    
    // 3.设置正在播放的音乐是上一首
    _playingMusic = previousMusic;
    
    return previousMusic;
}


@end
