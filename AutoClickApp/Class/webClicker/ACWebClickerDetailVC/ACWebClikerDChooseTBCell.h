//
//  ACWebClikerDChooseTBCell.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/31.
//

#import <UIKit/UIKit.h>
#import "ACXSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACWebClikerDChooseTBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tapNameL;
@property (weak, nonatomic) IBOutlet UILabel *delayNoticeL;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) ACXSlider *slider;
@property (nonatomic, copy) void (^valueChangeBlock) (int index);
-(void)refreshSliderwithValue:(NSInteger)valueNum;
@end

NS_ASSUME_NONNULL_END
