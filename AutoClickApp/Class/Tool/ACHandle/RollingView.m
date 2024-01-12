//
//  RollingView.m
//  HoldingBarrage
//
//  Created by 魏忠海 on 2018/8/21.
//  Copyright © 2018年 lingji001. All rights reserved.
//

#import "RollingView.h"

@interface RollingView ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RollingView



- (void)setModel:(HoldingModel *)model{
    _model = model;
    [self.contentLabel removeFromSuperview];
    self.contentLabel = nil;
    [self initLabel];
}

#pragma mark 初始化Label
- (void)initLabel{
    self.contentLabel = [UILabel new];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(self.mas_right).mas_offset(0);
    }];
    
    self.contentLabel.text = self.model.content;
    self.contentLabel.font = [UIFont fontWithName:self.model.fontName size:self.model.fontSize.floatValue * 2];
    self.contentLabel.textColor = self.model.color;
    CGFloat distance = UIScreen.mainScreen.bounds.size.height * 1 + [self.model.content sizeWithFont:[UIFont fontWithName:self.model.fontName size:self.model.fontSize.floatValue * 2] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 10)].width;
//    假设 667 像素 动画执行结束用了 3 秒钟
    CGFloat times = 5 / 667.0 * distance - self.model.speed.floatValue * 2;
    NSLog(@"%f",times);
    [UIView animateWithDuration:times delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.contentLabel.transform = CGAffineTransformMakeTranslation(- distance, 0);
    } completion:nil];
    NSLog(@"%f",distance);
}







@end
