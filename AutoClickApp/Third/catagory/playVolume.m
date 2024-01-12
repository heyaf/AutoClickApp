//
//  playVolume.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/9.
//

#import "playVolume.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation playVolume
+(void)playMusic{
    BOOL stopPlay = [kUserDefaults boolForKey:@"stopPlay"];
    if (!stopPlay) {
        //获取音效文件路径
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"playname" ofType:@"mp3"];
            //创建音效文件URL
            NSURL *fileUrl = [NSURL URLWithString:filePath];
            //音效声音的唯一标示ID
            SystemSoundID soundID = 0;
            //将音效加入到系统音效服务中，NSURL需要桥接成CFURLRef，会返回一个长整形ID，用来做音效的唯一标示
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
//            //设置音效播放完成后的回调C语言函数
//            AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,NULL,NULL);
            //开始播放音效
            AudioServicesPlaySystemSound(soundID);
    }
}
@end
