//
//  WJMusic.h
//  WJMusicPlayer
//
//  Created by Kevin on 15/4/2.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

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
