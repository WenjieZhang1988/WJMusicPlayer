//
//  WJLrcView.h
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  歌词面板View

#import "DRNRealTimeBlurView.h"

@interface WJLrcView : DRNRealTimeBlurView

@property (nonatomic, copy) NSString *lrcname;

@property (nonatomic, assign) NSTimeInterval currentTime;

@end
