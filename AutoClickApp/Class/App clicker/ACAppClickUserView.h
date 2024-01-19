//
//  ACAppClickUserView.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2024/1/18.
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACAppClickUserView : UIView
@property (strong,nonatomic) UIImageView *animation1;

@property (nonatomic, copy) void (^clickedBlock) (void);
@end

NS_ASSUME_NONNULL_END
