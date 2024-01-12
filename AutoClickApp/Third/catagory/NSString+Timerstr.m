//
//  NSString+Timerstr.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/4.
//

#import "NSString+Timerstr.h"

@implementation NSString (Timerstr)
+ (NSString *)nowTimeInterval {
    // 现在的时间戳
    
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    return timeStr;
}

//获取当前时间
+ (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}
+ (NSString *)timeWithYearMonthDayCountDown:(NSString *)timestamp {
    // 时间戳转日期
    
    // 传入的时间戳timeStr如果是精确到毫秒的记得要/1000
    NSTimeInterval timeInterval = [timestamp doubleValue]/1000;
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 实例化一个NSDateFormatter对象，设定时间格式，这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:detailDate];

    return dateStr;
}
@end
