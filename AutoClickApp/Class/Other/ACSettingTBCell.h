//
//  ACSettingTBCell.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACSettingTBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoimageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *rightimageV;
@property (nonatomic, strong) UISwitch *swiTch;
@property (nonatomic, copy) void(^reloadBlock) (void);
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@end

NS_ASSUME_NONNULL_END
