//
//  WJLrcCell.h
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  单行歌词Cell

#import <UIKit/UIKit.h>
@class WJLrcline;

@interface WJLrcCell : UITableViewCell

@property (nonatomic, strong) WJLrcline *lrcline;

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
