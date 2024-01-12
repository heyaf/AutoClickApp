//
//  UIFont+ACFont.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, BNFontBoldType){

    BNFontBoldTypeRegular,
    BNFontBoldTypeBold,
    BNFontBoldTypeMedium,
};
@interface UIFont (ACFont)
+ (UIFont *)fontWithBoldType:(BNFontBoldType)boldType size:(CGFloat)size;
+ (UIFont *)bn_regularFontWithSize:(CGFloat)size;
+ (UIFont *)bn_mediumFontWithSize:(CGFloat)size;
+ (UIFont *)bn_boldFontWithSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
