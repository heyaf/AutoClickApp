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

@interface AppDelegate ()<SKProductsRequestDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
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
    if ([kUserDefaults boolForKey:@"showPage"]) {
        
    } else {
        [kUserDefaults setBool:YES forKey:@"showPage"];
        ACGuiderPageVC *pushVC = [[ACGuiderPageVC  alloc] init];
        pushVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:pushVC animated:NO completion:nil];
        // 在全局队列中创建一个子线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 在这里执行子线程的代码
            [self getNet];
            
           
        });

    }
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

    return YES;
}
-(void)payDetail{
    NSArray * productArray = [[NSArray alloc] initWithObjects:IAP1_ProductID,IAP2_ProductID, nil];

        [self validateProductIdentifiers:productArray];//根据商品id获取商品详情信息,数组参数
    
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

    NSUserDefaults * productInfoDefaults = [NSUserDefaults standardUserDefaults];

    [productInfoDefaults setObject:productInfoArray forKey:@"productInfoDefaultsKey"];

    [productInfoDefaults synchronize];

    NSLog(@"%@",productInfoArray);

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

@end
