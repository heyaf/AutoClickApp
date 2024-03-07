//
//  AppDelegate.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/25.
//

#import "AppDelegate.h"
#import "ACTabViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "ACGuiderPageVC.h"
#import <StoreKit/StoreKit.h>
#import <XYStoreiTunesReceiptVerifier.h>
#import "STRIAPManager.h"

@interface AppDelegate ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
//    [self checkUserPayment];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // 在此设置内购的票据校验，防止掉单问题的发生
//    [[XYStore defaultStore] registerReceiptVerifier:[XYStoreiTunesReceiptVerifier shareInstance]];
    //设置默认语言
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
            //获得当前语言
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *language = [languages objectAtIndex:0];
            if([language hasPrefix:@"zh"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"ja"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"ja" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"ru"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"ru" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"fr"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"fr" forKey:@"appLanguage"];
            }else if([language hasPrefix:@"de"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"de" forKey:@"appLanguage"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ACTabViewController *tabBarVC = [[ACTabViewController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
//    if ([kUserDefaults boolForKey:@"showPage"]) {
//        
//    } else {
        [kUserDefaults setBool:YES forKey:@"showPage"];
        ACGuiderPageVC *pushVC = [[ACGuiderPageVC  alloc] init];
        pushVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:pushVC animated:NO completion:nil];
        // 在全局队列中创建一个子线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 在这里执行子线程的代码
            [self getNet];
            
           
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self payDetail];

        });

//    }
//    if (@available(iOS 13.0, *)) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
//    }
    
    NSInteger appCount = [kUserDefaults integerForKey:@"AppCount"];
    appCount ++;
    [kUserDefaults setInteger:appCount forKey:@"AppCount"];
    if (appCount == 3) {
        [SKStoreReviewController requestReview];
        self.hasShowStar = true;
    }
    
    [self payDetail];
//    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    NSString *receiptPath = receiptURL.path;
//
//    // 如果需要，您可以将文件路径读取成 NSData
//    NSData *receiptData = [NSData dataWithContentsOfFile:receiptPath];
//    [self verifyReceipt:receiptData];
    return YES;
}
-(void)payDetail{
    NSArray * productArray = [[NSArray alloc] initWithObjects: @"autoclicker_onapp",IAP1_ProductID,IAP2_ProductID, nil];

    [self validateProductIdentifiers:productArray];//根据商品id获取商品详情信息,数组参数
    
}
//检查用户是否是VIP
-(void)checkUserPayment{
   BOOL isVaildPayment1 = [[XYStoreiTunesReceiptVerifier shareInstance] isSubscribedWithAutoRenewProduct:IAP1_ProductID];
    BOOL isVaildPayment2 = [[XYStoreiTunesReceiptVerifier shareInstance] isSubscribedWithAutoRenewProduct:IAP2_ProductID];
    vipToolS *vipsettool = [[vipToolS alloc] init];
    BOOL isvip = [vipTool isVip];
    if(!isVaildPayment1&&!isVaildPayment2){
        if (isvip) {
            [vipsettool clearVip];
        }
    }else{
        if (!isvip) {
            if (isVaildPayment2) {
                [vipsettool setVipWithType:2];
            }else{
                [vipsettool setVipWithType:1];

            }
        }
    }

}
// 自定义方法

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers

{

    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]

                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];

    productsRequest.delegate = self;

    [productsRequest start];

}

//收到产品返回信息

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSArray *product = response.products;//获取到的商品信息列表

    if([product count] == 0){

        return;

    }

    SKProduct *p = nil;

    NSMutableArray * productInfoArray = [NSMutableArray array];

    for (SKProduct *pro in product) {

        NSNumberFormatter*numberFormatter = [[NSNumberFormatter alloc] init];

        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];

        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

        [numberFormatter setLocale:pro.priceLocale];

        NSString*formattedPrice = [numberFormatter stringFromNumber:pro.price];//例如 ￥12.00,如果是美元地区的话,单位会直接切换成美元,并且金额会根据汇率自动换算

          NSDictionary * dicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:formattedPrice,@"finalPrice",[pro productIdentifier],@"productIdentifier", nil];//把获取到的商品的价格和对应的商品id存储起来,用来展示充值界面

        [productInfoArray addObject:dicInfo];

    }
    // 使用 NSSortDescriptor 进行排序，按照价格从低到高
    // 自定义排序比较器
    NSArray *customOrder = @[@"autoclicker_onapp", @"AutoClicker_Month_Nofree", @"AutoClicker_Year_Nofree"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"productIdentifier" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger index1 = [customOrder indexOfObject:obj1];
        NSUInteger index2 = [customOrder indexOfObject:obj2];
        
        if (index1 < index2) {
            return NSOrderedAscending;
        } else if (index1 > index2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];

    NSArray *sortedArray = [productInfoArray sortedArrayUsingDescriptors:@[sortDescriptor]];

    
    NSUserDefaults * productInfoDefaults = [NSUserDefaults standardUserDefaults];

    [productInfoDefaults setObject:sortedArray forKey:@"productInfoDefaultsKey"];

    [productInfoDefaults synchronize];

    NSLog(@"123%@",sortedArray);

}
-(void)getNet{
 
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://wwww.baidu.com"]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
      @"Content-Type": @"application/x-www-form-urlencoded"
    };
    [request setAllHTTPHeaderFields:headers];

    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [kUserDefaults setBool:YES forKey:@"netWork"];
      if (error) {
        NSLog(@"%@", error);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
        dispatch_semaphore_signal(sema);
      }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);


}

// 实现交易观察者方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                // 处理购买成功的情况
                break;

            case SKPaymentTransactionStateRestored:
                // 处理已经购买过的情况
                break;
            case SKPaymentTransactionStateDeferred:
                // 处理交易暂时无法确认的情况（通常在家庭共享设置中）
                break;
            case SKPaymentTransactionStatePurchasing:
                // 交易进行中
                break;
            case SKPaymentTransactionStateFailed:
                            // 处理订阅被取消的情况
                        [self handlePurchaseFailure:transaction];
                        break;
            default:
                break;
        }
    }
}
// 处理购买失败的情况
- (void)handlePurchaseFailure:(SKPaymentTransaction *)transaction {
    if (transaction.error.code == SKErrorPaymentCancelled) { //处理收到用户取消订阅的消息
        vipToolS *vipsettool = [[vipToolS alloc] init];
        BOOL isvip = [vipTool isVip];
        if (isvip) {
            [vipsettool clearVip];
        }
        // 用户在支付过程中取消了付款
        [self handleCancelledPayment:transaction];
    } else {
        // 其他购买失败的情况
        [self handleOtherPurchaseFailure:transaction];
    }
}

// 处理用户在支付过程中取消了付款
- (void)handleCancelledPayment:(SKPaymentTransaction *)transaction {
    NSLog(@"用户取消了付款");
    // 在这里执行用户取消支付时的处理逻辑
    // 完成交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// 处理其他购买失败的情况
- (void)handleOtherPurchaseFailure:(SKPaymentTransaction *)transaction {
    NSLog(@"其他购买失败情况");
    // 在这里执行其他购买失败时的处理逻辑
    // 完成交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/// 请求苹果接口进行票据校验
- (void)localReceiptVerifyingWithUrl:(NSString *)requestUrl AndReceipt:(NSString *)receiptStr AndTransaction:(SKPaymentTransaction *)transaction
{
    NSDictionary *requestContents = @{@"receipt-data": receiptStr,};
    NSError *error;
    // 转换为 JSON 格式
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    NSString *verifyUrlString = requestUrl;
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // 在后台对列中提交验证请求，并获得官方的验证JSON结果
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"链接失败");
            
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                NSLog(@"验证失败");
                
            }
            NSLog(@"验证成功");
            //TODO:取这个json的数据去判断，道具是否下发
        }
    }];
    [task resume];
}
- (void)verifyReceipt:(NSData *)receiptData {
    // 获取票据
    NSString *base64EncodedReceipt = [receiptData base64EncodedStringWithOptions:0];

    // 构建请求数据
    NSDictionary *requestBody = @{@"receipt-data": base64EncodedReceipt};
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:&error];

    if (!error) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = requestData;

        // 发送请求
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                // 处理验证结果
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [self handleVerificationResult:jsonResponse];
            }
        }];

        [task resume];
    }
}

- (void)handleVerificationResult:(NSDictionary *)result {
    
    NSDictionary *receipt = [result objectForKey:@"receipt"];
    if (receipt){
        NSArray *array =  [receipt objectForKey:@"in_app"];
        if (array && array.count > 0){
            NSDictionary *fistDic = array.firstObject;
            if (fistDic){
                //取到最后 一单的 transaction_id ，如果a看到这个一单没有 提交过，那么异常单中 的相同的
                //product_id 对应的单应该是同一单，那么提交给 服务器
                NSString *product_id = [fistDic objectForKey:@"product_id"];
                NSString *transaction_id = [fistDic objectForKey:@"transaction_id"];
                NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
                NSLog(@"123");
            }
        }
    }
    // 解析验证结果，判断购买是否有效
    BOOL purchaseValid = [result[@"status"] integerValue] == 0;

    if (purchaseValid) {
        // 购买有效，处理相应逻辑
        NSLog(@"购买有效");
    } else {
        // 购买无效，处理相应逻辑
        NSLog(@"购买无效");
    }
}

@end
