//
//  NSDate+DateStr.m
//  ZZProject
//
//  Created by heyafei on 2022/8/7.
//

#import "NSDate+DateStr.h"

@implementation NSDate (DateStr)
+(NSDate *)getNewDateDistanceNowWithYear:(NSInteger)year withMonth:(NSInteger)month withDays:(NSInteger)days

{

    

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comps = nil;

    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];

    NSDateComponents *adcomps = [[NSDateComponents alloc]init];

    [adcomps setYear:year];//year=1表示1年后的时间 year=-1为1年前的日期

    [adcomps setMonth:month];

    [adcomps setDay:days];

    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];

    

    return newdate;

}
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
//字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    if (dateString.length==0) {
        return [NSDate now];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];

    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
+ (NSInteger )compareDate:(NSDate* )aDate withDate:(NSDate* )bDate

{
    
        NSInteger tag = 0;
    
        NSComparisonResult result = [aDate compare:bDate];
    
        if(result == NSOrderedSame)
        
            {
            
                    //相等
            
                    tag=0;
            
                }
    
        else if (result == NSOrderedAscending)
        
            {
            
                    //bDate比aDate大
            
                    tag = 1;
            
                }
    
        else
        
            {
            
                    //bDate比aDate小
            
                    tag = -1;
            
                }
    
        return tag;
    
}

@end
