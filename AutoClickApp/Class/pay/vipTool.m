//
//  vipTool.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/16.
//

#import "vipTool.h"
#import "NSDate+DateStr.h"

@implementation vipTool
+ (BOOL) isVip{
    NSString *str = [kUserDefaults valueForKey:@"payInfo"];
    if (k_isValidString(str)&&[NSDate compareDate:[NSDate stringToDate:str withDateFormat:@"yyyy-MM-dd HH:mm:ss"] withDate:[NSDate now]]==-1) {
        return true;
    }
    return false;
}
@end
