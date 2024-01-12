//
//  UIView+ACShortCreat.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ACShortCreat)
/** 快速创建label */
- (UILabel *)createLabelFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font;
- (UILabel *)createLabelTextColor:(UIColor *)color font:(UIFont *)font;

/** 快速创建按钮 */
- (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font image:(nullable UIImage *)image target:(id)target method:(SEL)method;

/** 快速创建输入框 */
- (UITextField *)createTextFieldFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font;
///创建线条
- (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
