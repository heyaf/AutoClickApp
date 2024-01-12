//
//  ACToolListTBCell.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACToolListTBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *vipIcon;

@end

NS_ASSUME_NONNULL_END
