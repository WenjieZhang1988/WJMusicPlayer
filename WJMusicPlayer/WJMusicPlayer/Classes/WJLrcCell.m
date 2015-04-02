//
//  WJLrcCell.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "WJLrcCell.h"
#import "WJLrcline.h"

@implementation WJLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lrcCell";
    WJLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WJLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        // 1.去除cell的背景
        cell.backgroundColor = [UIColor clearColor];
        // 2.设置cell文字为白色
        cell.textLabel.textColor = [UIColor whiteColor];
        // 3.设置点击的样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 4.设置文字居中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)setLrcline:(WJLrcline *)lrcline
{
    _lrcline = lrcline;
    
    self.textLabel.text = lrcline.text;
}

@end
