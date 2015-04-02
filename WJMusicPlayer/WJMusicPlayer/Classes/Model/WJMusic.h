//
//  WJMusic.h
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  歌曲模型

#import <Foundation/Foundation.h>

@interface WJMusic : NSObject

/**
 *  歌曲名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  歌曲对应的文件名称
 */
@property (nonatomic, copy) NSString *filename;
/**
 *  歌词名称
 */
@property (nonatomic, copy) NSString *lrcname;
/**
 *  歌手
 */
@property (nonatomic, copy) NSString *singer;
/**
 *  歌手的头像
 */
@property (nonatomic, copy) NSString *singerIcon;
/**
 *  歌手的封面
 */
@property (nonatomic, copy) NSString *icon;

@end
