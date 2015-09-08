//
//  YQAudioTool.h
//  播放音频文件
//
//  Created by 代玉钦 on 15/7/29.
//  Copyright (c) 2015年 YQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQAudioTool : NSObject
+ (void)playSoundWithFileName:(NSString *)fileName;

+ (void)disposeSoundWithFileName:(NSString *)fileName;
@end
