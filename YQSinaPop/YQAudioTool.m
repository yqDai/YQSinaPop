//
//  YQAudioTool.m
//  播放音频文件
//
//  Created by 代玉钦 on 15/7/29.
//  Copyright (c) 2015年 YQ. All rights reserved.
//

#import "YQAudioTool.h"
#import <AVFoundation/AVFoundation.h>
static NSMutableDictionary *soundIDDic;

@implementation YQAudioTool

+ (void)initialize
{
    soundIDDic = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithFileName:(NSString *)fileName
{
    if (fileName == nil) return;
    SystemSoundID soundID = [soundIDDic[fileName] intValue];
    if (!soundID)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (!url) return;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        soundIDDic[fileName] = @(soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeSoundWithFileName:(NSString *)fileName
{
    if (fileName == nil) return;
    SystemSoundID soundID = [soundIDDic[fileName] intValue];
    if (soundID)
    {
        AudioServicesDisposeSystemSoundID(soundID);
        [soundIDDic removeObjectForKey:fileName];
    }
}

@end
