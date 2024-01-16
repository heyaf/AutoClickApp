//
//  NSDate+DateStr.h
//  ZZProject
//
//  Created by heyafei on 2022/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DateStr)
/**

 获取距离当前时间多久的一个日期



 @param year year=1表示1年后的时间 year=-1为1年前的日期

 @param month 距离现在几个月

 @param days 距离现在几天

 @return 返回一个新的日期

 */
+(NSDate*)getNewDateDistanceNowWithYear:(NSInteger)year withMonth:(NSInteger)month withDays:(NSInteger)days;

//字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;

+ (NSInteger )compareDate:(NSDate* )aDate withDate:(NSDate* )bDate;
@end

NS_ASSUME_NONNULL_END
