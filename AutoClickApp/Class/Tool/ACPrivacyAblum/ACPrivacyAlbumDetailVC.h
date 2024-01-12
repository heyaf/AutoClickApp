//
//  ACPrivacyAlbumDetailVC.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACPrivacyAlbumDetailVC : UIViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) void(^refreshBlock) (void);


@end

NS_ASSUME_NONNULL_END
