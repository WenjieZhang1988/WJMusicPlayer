//
//  AppDelegate.m
//  WJMusicPlayer
//
//  Created by Kevin on 14/4/14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.拿到AVAudioSession单例对象
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 2.设置类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 3.激活
    [session setActive:YES error:nil];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 设置应用可后台执行
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

@end
