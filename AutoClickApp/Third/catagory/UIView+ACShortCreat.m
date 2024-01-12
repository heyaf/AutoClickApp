//
//  UIView+ACShortCreat.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/27.
//

#import "UIView+ACShortCreat.h"

@implementation UIView (ACShortCreat)
- (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color {

    UIView *view = [[UIView alloc] initWithFrame:frame];

    view.backgroundColor = color;
    [self addSubview:view];
    return view;
}

- (UILabel *)createLabelFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font {

    UILabel *view = [[UILabel alloc] initWithFrame:frame];

    view.textColor = color;
    view.font = font;
    [self addSubview:view];
    //view.textAlignment = alignment;
    return view;
}

- (UILabel *)createLabelTextColor:(UIColor *)color font:(UIFont *)font {

    UILabel *view = [[UILabel alloc] init];

    view.textColor = color;
    view.font = font;
    [self addSubview:view];
    //view.textAlignment = alignment;
    return view;
}

- (UITextField *)createTextFieldFrame:(CGRect)frame textColor:(UIColor *)color font:(UIFont *)font {
    
    UITextField *view = [[UITextField alloc] initWithFrame:frame];
    
    view.textColor = color;
    view.font = font;
    [self addSubview:view];
    return view;
}


- (UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font image:(nullable UIImage *)image target:(id)target method:(SEL)method {
    
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = frame;
    if (text) {
        [view setTitle:text forState:UIControlStateNormal];
        view.titleLabel.font = font;
        [view setTitleColor:color forState:UIControlStateNormal];
    }
    if (image) {
        [view setImage:image forState:UIControlStateNormal];

    }
    view.adjustsImageWhenHighlighted = NO;
    [view addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:view];
    return view;
}

@end
