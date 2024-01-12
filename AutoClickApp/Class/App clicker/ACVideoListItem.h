//
//  ACVideoListItem.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACVideoListItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@end

NS_ASSUME_NONNULL_END
