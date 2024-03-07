//
//  UIButton+animation.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/10.
//

#import "UIButton+animation.h"

@implementation UIButton (animation)
+(void)setanimationwithBtn:(UIButton *)btn{
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                btn.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
@end
