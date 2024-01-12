//
//  NSString+Timerstr.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Timerstr)
+ (NSString *)nowTimeInterval;
//获取当前时间
+ (NSString *)currentDateStr;

+ (NSString *)timeWithYearMonthDayCountDown:(NSString *)timestamp ;
@end

NS_ASSUME_NONNULL_END
