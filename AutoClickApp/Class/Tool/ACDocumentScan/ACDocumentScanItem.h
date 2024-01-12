//
//  ACDocumentScanItem.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACDocumentScanItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainimageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

NS_ASSUME_NONNULL_END
