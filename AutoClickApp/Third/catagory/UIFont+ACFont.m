//
//  UIFont+ACFont.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "UIFont+ACFont.h"

@implementation UIFont (ACFont)

+ (UIFont *)fontWithBoldType:(BNFontBoldType)boldType size:(CGFloat)size {
    NSString *regularFontName;
    NSString *mediumFontName;
    NSString *boldFontName;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0f) {
        regularFontName = @"HelveticaNeue";//常规
        mediumFontName = @"HelveticaNeue-Medium";//加粗
        boldFontName = @"HelveticaNeue-Bold";
    }else {
        regularFontName = @"PingFangSC-Regular";
        mediumFontName = @"PingFangSC-Medium";
        boldFontName = @"PingFangSC-Semibold";
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    CGFloat ratio = (SCREEN_WIDTH > 320 && SCREEN_HEIGHT > 568) ? 1 : kScreenWidthRatio(1);
    CGFloat ratio = 1.0;
    if (boldType == BNFontBoldTypeRegular) {
        return [UIFont fontWithName:regularFontName size:size * ratio];
    }else if(boldType == BNFontBoldTypeBold){
        //        return [UIFont fontWithName:mediumFontName size:size * ratio];
        return [UIFont fontWithName:boldFontName size:size * ratio];
    }else if(boldType == BNFontBoldTypeMedium){
        return [UIFont fontWithName:mediumFontName size:size * ratio];
    }
#pragma clang diagnostic pop
    return nil;
}

+ (UIFont *)bn_regularFontWithSize:(CGFloat)size {
    return [UIFont fontWithBoldType:(BNFontBoldTypeRegular) size:size+2];
}

+ (UIFont *)bn_mediumFontWithSize:(CGFloat)size {
    return [UIFont fontWithBoldType:(BNFontBoldTypeMedium) size:size+2];
}

+ (UIFont *)bn_boldFontWithSize:(CGFloat)size {
    return [UIFont fontWithBoldType:(BNFontBoldTypeBold) size:size+2];
}
@end
