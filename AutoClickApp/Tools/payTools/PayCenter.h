//
//  PayCenter.h
//  TestPay
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface PayCenter : NSObject


//全局管理对象
+ (PayCenter *)sharedInstance;

//- (void)payWithMoney:(NSInteger)money andType:(PayType)type dataDic:(NSDictionary *)dataDic;


- (void)startManager;
- (void)stopManager;


@property (nonatomic, copy) void (^paySuccessBlock) (void);
@property (nonatomic, copy) void (^payfailBlock) (void);

@property (nonatomic, copy) void (^restorSuccessBlock) (void);
@property (nonatomic, copy) void (^restorfailBlock) (void);
- (void)payItem:(NSString *)IAP_ID;
- (void)restorePay;
@end

NS_ASSUME_NONNULL_END
