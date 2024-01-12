//
//  ACPrivacyPhotoDetailVC.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACPrivacyPhotoDetailVC : UIViewController

@property (nonatomic, strong) NSString *pathStr;
@property (nonatomic, strong) NSString *videoStr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) void(^refreshBlock) (void);
@end

NS_ASSUME_NONNULL_END
