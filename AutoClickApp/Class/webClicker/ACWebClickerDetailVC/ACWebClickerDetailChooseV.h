//
//  ACWebClickerDetailChooseV.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACWebClickerDetailChooseV : UIView
@property (nonatomic, copy) void (^closeAction)(void);

@property (nonatomic, assign) NSInteger repeatNum; //重复次数

@property (nonatomic, strong) NSMutableArray *delayTimeArr;

@property (nonatomic, copy) void (^countChangeBlock)(void);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
