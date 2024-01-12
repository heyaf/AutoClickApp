//
//  ACColorView.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACColorView : UIView

@property (nonatomic, copy) void (^selectColorBlock)(NSInteger index,NSString *colorStr);
@end

NS_ASSUME_NONNULL_END
