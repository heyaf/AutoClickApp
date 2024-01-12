//
//  ACPrivacyAblumItem.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACPrivacyAblumItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;
//@property (weak, nonatomic) IBOutlet UIImageView *playImageV;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageV;

@end

NS_ASSUME_NONNULL_END
