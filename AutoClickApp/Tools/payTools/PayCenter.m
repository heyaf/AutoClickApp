//
//  PayCenter.m
//  TestPay
//
//  Created by Apple on 2019/10/15.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "PayCenter.h"
#import <StoreKit/StoreKit.h>
#import <XYIAPKit.h>
/**
 *  单例宏方法
 *
 *  @param block
 *
 *  @return 返回单例
 */
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@interface PayCenter () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end

@implementation PayCenter

+ (PayCenter *)sharedInstance{
    //初始化单例类
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[PayCenter alloc] init];
    });
}

- (id)init{
    self = [super init];
    if (self) {
        
        [self startManager];
    }
    
    return self;
}

- (void)startManager { //开启监听
    /*
     在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
     */
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)stopManager{ //移除监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)payItem:(NSString *)IAP_ID{
    
    //检查用户允许app内购
    if([SKPaymentQueue canMakePayments]){
        
        if(IAP_ID && IAP_ID.length > 0){
            
            NSArray *product = [[NSArray alloc] initWithObjects:IAP_ID, nil];
            NSSet *nsSet = [NSSet setWithArray:product];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsSet];
            request.delegate = self;
            [request start];
        }else{
           //商品为空
            [MBProgressHUD showErrorMessage:@"支付失败，商品为空"];
        }
    }else{
        //没有权限
        [MBProgressHUD showErrorMessage:@"支付失败，没有权限"];

    }
}
- (void)restorePay{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];//发起请求

}
//恢复失败
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    if (_restorfailBlock) {
        _restorfailBlock();
    }
}
// 恢复成功后的回调
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{

   if (queue.transactions.count) {
       for (SKPaymentTransaction *tran in queue.transactions) {
           if (tran.originalTransaction.transactionIdentifier) {
               
               break;
           }
       }
       // 没有可恢复的购买项
       NSLog(@"恢复成功");
       if (_restorSuccessBlock) {
           _restorSuccessBlock();
       }
//       NSDictionary *userInfo = @{ XYStoreNotificationTransactions : restoredTransactions };
//       [[NSNotificationCenter defaultCenter] postNotificationName:XYSKRestoreTransactionsFinished object:self userInfo:userInfo];
   } else {
       // 没有可恢复的购买项
       NSLog(@"恢复失败");
       if (_restorfailBlock) {
           _restorfailBlock();
       }
   }
}

#pragma mark SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (product.count == 0) {
        //无法获取商品信息
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程上执行的代码
            // 这里可以放置需要在主线程上执行的任务
            [MBProgressHUD showErrorMessage:@"支付失败，无法获取商品信息"];
            if (self.payfailBlock) {
                self.payfailBlock();
            }
        });

    } else {
        //发起购买请求
        SKPayment * payment = [SKPayment paymentWithProduct:product[0]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark SKProductsRequestDelegate 查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    //查询失败: [error localizedDescription];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 在主线程上执行的代码
            ///购买失败
            [MBProgressHUD showErrorMessage:KLanguage(@"Failed purchase")];

        });


    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //用户取消了交易
            [MBProgressHUD showErrorMessage:KLanguage(@"Cancel purchase")];

        });


    }
    //将交易结束
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma Mark 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"--------%@",transactions);
    bool ispayed = true;
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState != SKPaymentTransactionStatePurchased) {
            ispayed = false;
        }
    }

    if (ispayed && transactions.count > 1) {
        return;
    }
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing://正在交易
                NSLog(@"正在交易");
                break;
                
            case SKPaymentTransactionStatePurchased://交易完成
            {
                NSLog(@"交易完成");
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

                if (self.paySuccessBlock) {
                    self.paySuccessBlock();
                }

            }
                break;
                
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                NSLog(@"交易失败");

                if (self.payfailBlock) {
                    self.payfailBlock();
                }
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"已经购买过");

                if (self.payfailBlock) {
                    self.payfailBlock();
                }
                break;
            default:
                break;
        }
    }
}


@end
