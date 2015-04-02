//
//  WJMusicsViewController.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "WJMusicsViewController.h"
#import "WJMusic.h"
#import "UIImage+Circle.h"
#import "WJPlayingViewController.h"
#import "WJMusicTool.h"

@interface WJMusicsViewController ()

// 正在播放的控制器
@property (nonatomic, strong) WJPlayingViewController *playingVc;

@end

@implementation WJMusicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 改变cell的高度
    self.tableView.rowHeight = 80;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [WJMusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MusicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 1.取出模型对象
    WJMusic *music = [WJMusicTool musics][indexPath.row];
    
    // 2.给cell设置数据
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:2.0 borderColor:[UIColor magentaColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.让cell变为不选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 1.取出模型对象
    WJMusic *music = [WJMusicTool musics][indexPath.row];
    [WJMusicTool setPlayingMusic:music];
    
    // 2.弹出控制器
    [self.playingVc show];
}

#pragma mark - 懒加载代码
- (WJPlayingViewController *)playingVc
{
    if (_playingVc == nil) {
        _playingVc = [[WJPlayingViewController alloc] init];
    }
    
    return _playingVc;
}

@end
