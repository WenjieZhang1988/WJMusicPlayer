//
//  WJLrcView.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "WJLrcView.h"
#import "UIView+AdjustFrame.h"
#import "WJLrcCell.h"
#import "WJLrcline.h"

@interface WJLrcView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *lrclines;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation WJLrcView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

#pragma mark - 初始化一个tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrclines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建Cell
    WJLrcCell *lrcCell = [WJLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentIndex == indexPath.row) {
        lrcCell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        lrcCell.textLabel.textColor = [UIColor magentaColor];
    } else {
        lrcCell.textLabel.font = [UIFont systemFontOfSize:13.0];
        lrcCell.textLabel.textColor = [UIColor whiteColor];
    }
    
    // 2.给cell设置数据
    lrcCell.lrcline = self.lrclines[indexPath.row];
    
    return lrcCell;
}

#pragma mark - 重写setLrcname方法
- (void)setLrcname:(NSString *)lrcname
{
    // 1.保留歌曲的文件的名称
    _lrcname = lrcname;
    
    // 2.加载文件中的歌曲
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 3.解析歌词
    // 3.1.切换字符串
    NSArray *lrcLines = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcLine in lrcLines) {
        // 3.2.移除不需要的行
        if ([lrcLine hasPrefix:@"[ti"] || [lrcLine hasPrefix:@"[ar"] || [lrcLine hasPrefix:@"[al"] || ![lrcLine hasPrefix:@"["]) {
            continue;
        }
        // 3.3.截取单行
        WJLrcline *lrcline = [[WJLrcline alloc] init];
        NSArray *lrcs = [lrcLine componentsSeparatedByString:@"]"];
        lrcline.text = [lrcs lastObject];
        lrcline.time = [[lrcs firstObject] substringFromIndex:1];
        
        // 3.4.将模型对象添加到数组中
        [tempArray addObject:lrcline];
    }
    self.lrclines = tempArray;
    
    // 4.刷新数据
    [self.tableView reloadData];
}

#pragma mark - 重写setCurrentTime方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 0.传入时间和之前保存的时间对比
    if (_currentTime > currentTime) {
        self.currentIndex = -1;
    }
    
    // 1.保存当前的时间
    _currentTime = currentTime;
    
    // 2.将传入的时间转成字符串
    NSInteger min = currentTime / 60;
    NSInteger second = (NSInteger)currentTime % 60;
    NSInteger mSecond = (currentTime - (NSInteger)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld.%02ld", min, second, mSecond];
    
    // 3.当前的时间,和数组中的所有时间对比
    NSInteger count = self.lrclines.count;
    for (NSInteger i = self.currentIndex + 1; i < count; i++) {
        // 1.取出i的模型
        WJLrcline *lrcline = self.lrclines[i];
        NSString *lrclineTimeStr = lrcline.time;
        
        // 2.取出i+1模型
        NSInteger nextIndex = i + 1;
        if (nextIndex < count) {
            WJLrcline *nextLrcline = self.lrclines[nextIndex];
            NSString *nextLrclineTimeStr = nextLrcline.time;
            
            // 3.比较时间
            if ([currentTimeStr compare:lrclineTimeStr] != NSOrderedAscending &&
                [currentTimeStr compare:nextLrclineTimeStr] != NSOrderedDescending && self.currentIndex != i) {
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                self.currentIndex = i;
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath1, indexPath2] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
    }
}

@end
