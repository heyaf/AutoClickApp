//
//  ACWebClikerDChooseTBCell.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/31.
//

#import "ACWebClikerDChooseTBCell.h"
@implementation ACWebClikerDChooseTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    
 
}
-(void)refreshSliderwithValue:(NSInteger)valueNum{
    [_slider removeFromSuperview];
    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i<=120; i++) {
        [valueArr addObject:kStringFormat(@"%.1f",i/2.0)];
    }
    _slider=[[ACXSlider alloc] initWithFrame:CGRectMake(30, 80, kScreenW-60, 50) titles:valueArr firstAndLastTitles:@[@"0.5",@"60"] defaultIndex:valueNum sliderImage:[UIImage imageNamed:@"slider_yuan"]];
    [self.contentView addSubview:_slider];
    kWeakSelf(self);
    _slider.block=^(int index){
        
        NSDictionary *patam = @{@"value":@(index),
                                @"index":@(weakself.tag - 1000)};
        KPostNotification(@"cellChangeValue", nil, patam);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
