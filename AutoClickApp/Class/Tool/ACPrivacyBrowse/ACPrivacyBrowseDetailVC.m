//
//  ACPrivacyBrowseDetailVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/6.
//

#import "ACPrivacyBrowseDetailVC.h"
#import <WebKit/WebKit.h>

@interface ACPrivacyBrowseDetailVC ()<UISearchBarDelegate,WKNavigationDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic ,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) BOOL loadingSuccess; //加载成功
@property (nonatomic, strong) NSMutableArray *urlArr;

@property (nonatomic, strong) UIView *bottmView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *urlArr1;
@property (nonatomic, assign) NSInteger index; //当前是在第几个页面
//是否是返回上一级
@property (nonatomic, assign) BOOL isback;
@property (nonatomic, assign) BOOL isRightClicked;
@property (nonatomic, assign) BOOL isrefresh;
@property (nonatomic,assign) BOOL canCollect;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UITextField *renameTF;

@end

@implementation ACPrivacyBrowseDetailVC
-(NSMutableArray *)urlArr{LazyMutableArray(_urlArr)}
- (NSMutableArray *)urlArr1{LazyMutableArray(_urlArr1)}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.mainBlackColor;
    
    NSArray *arr = [kUserDefaults objectForKey:@"privacyBrowse"];
    for (NSDictionary *dic in arr) {
        [self.urlArr addObject:dic[@"url"]];
    }


    [self.view addSubview:self.topV];
    self.loadingSuccess = NO;

    [self.view addSubview:self.wkWebView];

    if(self.urlStr.length>0){
        NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.wkWebView loadRequest:request];
        if([self.urlArr containsObject:self.urlStr]){
            self.collectBtn.selected = YES;
        }else{
            self.collectBtn.selected = NO;

        }
    }else{
        [self.collectBtn setImage:kIMAGE_Name(@"collect_un") forState:0];
        [self.collectBtn setImage:kIMAGE_Name(@"collect_un") forState:UIControlStateSelected];
        [self.searchBar.searchTextField becomeFirstResponder];
    }

    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.progressView.backgroundColor = [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#8A38F5"];
        [self.wkWebView addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.index = 0;
    [self.view addSubview:self.bottmView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = NO;
        
        // 提供方法给js调用
//        [UserContentController addScriptMessageHandler:self name:@"gotoActive"];
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenW, kScreenH-kNavBarHeight-kTabBarHeight) configuration:Configuration];
        
       
        _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        //开启手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.bounces = NO;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
       
        _wkWebView.navigationDelegate = self;
        
    }
    return _wkWebView;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchStr = searchBar.searchTextField.text;
    if (searchStr.length==0) {
        return;
    }
    self.urlStr = [self urlDesign:searchStr];;
    NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
    [searchBar.searchTextField resignFirstResponder];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
   
    // 获取url
    NSURLRequest * request = navigationAction.request;
    NSString * requestStr = request.URL.absoluteString;
    if([requestStr hasPrefix:@"www."]){
        requestStr = kStringFormat(@"https://%@",requestStr);
    }
    if (self.isrefresh) {
        self.isrefresh = false;
    }else if(self.isRightClicked){
        self.isRightClicked = NO;
    }else{
        if(self.isback){
            self.isback = NO;
        } else{
            self.index = self.urlArr1.count;
            [self.urlArr1 addObject:requestStr];

        }
    }


    [self refreshButtonStatues];
    decisionHandler(WKNavigationActionPolicyAllow);

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    weakSelf.progressView.hidden = YES;
                    
                }];});
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    self.loadingSuccess = NO;
    [self.collectBtn setImage:kIMAGE_Name(@"collect_un") forState:0];
    [self.collectBtn setImage:kIMAGE_Name(@"collect_un") forState:UIControlStateSelected];
    //开始加载网页时展示出progressView
    dispatch_async(dispatch_get_main_queue(), ^{
            // 需要在主线程执行的代码
        self.progressView.hidden = NO;
        //开始加载网页的时候将progressView的Height恢复为1.5倍
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        //防止progressView被网页挡住
        [self.wkWebView bringSubviewToFront:self.progressView];
    });

}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.loadingSuccess = YES;
    if([self ChanrgeCanCollect]){
        [self.collectBtn setImage:kIMAGE_Name(@"browse6") forState:0];
        [self.collectBtn setImage:kIMAGE_Name(@"browse7") forState:UIControlStateSelected];
    }
   
    if([self.urlArr containsObject:self.urlStr]){
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;

    }
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(UIView *)topV{
    if(!_topV){
        _topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kNavBarHeight)];
        _topV.backgroundColor = UIColor.mainBlackColor;
        
        UIButton *backBtn = [UIButton buttonWithType:0];
        backBtn.frame = CGRectMake(6, kStatusBarHeight+2, 40, 40);
        [backBtn setImage:kIMAGE_Name(@"back_w") forState:0];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_topV addSubview:backBtn];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+4, kScreenW-100, 36)];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.placeholder = KLanguage(@"Search Any Website");
        searchBar.delegate = self;
        kViewRadius(searchBar, 10);
        searchBar.searchTextField.textColor = kWhiteColor;
        searchBar.backgroundColor = [UIColor colorWithHexString:@"#272226"];;
        [searchBar setImage:kIMAGE_Name(@"search_icon") forSearchBarIcon:UISearchBarIconSearch state:0];
        UITextField *textfield;
        if (@available(iOS 13.0, *)) {
            textfield = [searchBar searchTextField];
        } else {
            textfield = [searchBar valueForKey:@"_searchField"];
        }
        searchBar.searchTextField.borderStyle = UITextBorderStyleNone;
        textfield.delegate = self;
        //修改placeHolder的颜色
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:KLanguage(@"Search Any Website") attributes:@{NSForegroundColorAttributeName : kRGBA(255, 255, 255, 0.7)}];
        textfield.attributedPlaceholder = placeholderString;
        [_topV addSubview:searchBar];
        self.searchBar = searchBar;
        _searchBar.searchTextField.text = self.urlStr;
        _searchBar.searchTextField.returnKeyType = UIReturnKeyGo;
        
        _searchBar.delegate = self;
        
        UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-50,kStatusBarHeight + 12, 50, 18)];
        [collectBtn setImage:kIMAGE_Name(@"browse6") forState:0];
        [collectBtn setImage:kIMAGE_Name(@"browse7") forState:UIControlStateSelected];
        [collectBtn setShowsTouchWhenHighlighted:NO];
        [_topV addSubview:collectBtn];
        [collectBtn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
        _collectBtn = collectBtn;
        if (![self ChanrgeCanCollect]) {
            [collectBtn setImage:kIMAGE_Name(@"collect_un") forState:0];
            [collectBtn setImage:kIMAGE_Name(@"collect_un") forState:UIControlStateSelected];
        }
        collectBtn.adjustsImageWhenHighlighted = NO;
        UIButton *cancleBtn = [UIButton buttonWithType:0];
        [cancleBtn setTitle:KLanguage(@"Cancel") forState:0];
        cancleBtn.frame = CGRectMake(kScreenW-80, kStatusBarHeight + 12, 70, 18);
        [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#ACA9AC"] forState:0];
        [_topV addSubview:cancleBtn];
        self.cancleBtn = cancleBtn;
        [cancleBtn addTarget:self action:@selector(cancleBtnclicked) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.hidden = YES;
 
    }
    return _topV;
}
-(void)cancleBtnclicked{
    //[playVolume playMusic];
    [_searchBar.searchTextField resignFirstResponder];
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)collectionAction:(UIButton *)button{
    if(self.urlStr.length==0){
        return;
    }
    if (!self.loadingSuccess) {
        return;
    }
    if(![self ChanrgeCanCollect]){
        return;
    }
    //[playVolume playMusic];

    button.selected = !button.isSelected;
    if([self.urlArr containsObject:self.urlStr]){
        NSArray *arr = [kUserDefaults objectForKey:@"privacyBrowse"];
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];

        for (int i =0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"url"] isEqualToString:self.urlStr]) {
                [arr1 removeObjectAtIndex:i];
            }
        }
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr2 forKey:@"privacyBrowse"];
    }else{
        [self addUrl];
        
       
    }
}
-(void)addUrl{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLanguage(@"Delete")
                                                                             message:KLanguage(@"Are you sure you want to delete")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIView *view = alertController.view.subviews.firstObject;
    UIView *view1 = view.subviews.firstObject;
    UIView *view2 = view1.subviews.firstObject;



    __weak typeof(self) weakSelf = self;
    view2.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.75];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:KLanguage(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!self.renameTF||self.renameTF.text.length==0) {
            return;
        }
        NSArray *arr = [kUserDefaults objectForKey:@"privacyBrowse"];
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];

            [arr1 addObject:      @{@"name":self.renameTF.text,
                                    @"url":self.urlStr,
                                    @"icon":@"browse5"}];
  
        NSArray *arr2 = [NSArray arrayWithArray:arr1];
        [kUserDefaults setObject:arr2 forKey:@"privacyBrowse"];
      
       }];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KLanguage(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       }];
    // 2.1 添加文本框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = KLanguage(@"Name this webpage");
            textField.textColor = kWhiteColor;
            UIView *view = textField.superview;
            view.backgroundColor = [UIColor colorWithHexString:@"#1E1E1E" alpha:0.05];
            self.renameTF = textField;
        }];
       [alertController addAction:okAction];           // A
       [alertController addAction:cancelAction];       // B
    
    // 使用富文本来改变alert的title字体大小和颜色
    NSString * str1 = KLanguage(@"Enter the name new");
      NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:str1];
    [titleText addAttributes:@{NSFontAttributeName:kBoldFont(17),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str1.length)];
      [alertController setValue:titleText forKey:@"attributedTitle"];
      
      // 使用富文本来改变alert的message字体大小和颜色
      // NSMakeRange(0, 2) 代表:从0位置开始 两个字符
    NSString * str = KLanguage(@"Please give the web page you want tobookmark a name new");
      NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:str];
    [messageText addAttributes:@{NSFontAttributeName:kFont(13),NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, str.length)];
      [alertController setValue:messageText forKey:@"attributedMessage"];

    [self presentViewController:alertController animated:YES completion:nil];
}
-(UIView *)bottmView{
    if(!_bottmView){
        _bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, kTabBarHeight)];
        _bottmView.backgroundColor = [UIColor mainBlackColor];
        
       
        CGFloat marginL = (kScreenW-32-40*4)/3;
        
        UIButton *leftBtn = [UIButton buttonWithType:0];
        leftBtn.frame = CGRectMake(16, 5, 40, 40);
        [_bottmView addSubview:leftBtn];
        [leftBtn setImage:kIMAGE_Name(@"backright") forState:0];
        [leftBtn setImage:kIMAGE_Name(@"backright_un") forState:UIControlStateSelected];
        

        [leftBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:0];
        rightBtn.frame = CGRectMake(16+40+marginL, 5, 40, 40);
        [_bottmView addSubview:rightBtn];
        [rightBtn setImage:kIMAGE_Name(@"goright") forState:0];
        [rightBtn setImage:kIMAGE_Name(@"goright_an") forState:UIControlStateSelected];

        [rightBtn addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn = leftBtn;
        self.rightBtn = rightBtn;
        UIButton *menuBtn = [UIButton buttonWithType:0];
        menuBtn.frame = CGRectMake(16+(40+marginL)*2, 5, 40, 40);
        [_bottmView addSubview:menuBtn];
        [menuBtn setImage:kIMAGE_Name(@"share_icon") forState:0];
        [menuBtn addTarget:self action:@selector(menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [menuBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        UIButton *refreshBtn = [UIButton buttonWithType:0];
        refreshBtn.frame = CGRectMake(16+(40+marginL)*3, 5, 40, 40);
        [_bottmView addSubview:refreshBtn];
        [refreshBtn setImage:kIMAGE_Name(@"refresh") forState:0];
        [refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottmView;
}
-(void)leftClicked{
    //[playVolume playMusic];

    if(self.index>0&&self.urlArr1.count>1){
        self.isback = YES;
        self.index--;
        NSString *url = [self.urlArr1 objectAtIndex:self.index];
        self.urlStr = url;
        NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url1 = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        [self.wkWebView loadRequest:request];
    }
}
-(void)rightClicked{
    //[playVolume playMusic];

    if(self.index<self.urlArr.count-1&&self.urlArr1.count>1){
        self.isRightClicked = YES;
        self.index++;
        NSString *url = [self.urlArr1 objectAtIndex:self.index];
        self.urlStr = url;
        NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url1 = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        [self.wkWebView loadRequest:request];
    }
}
-(void)refreshButtonStatues{
    if(self.index==0){
        if(self.urlArr1.count>1){
            self.rightBtn.selected = NO;
        }else{
            self.rightBtn.selected = YES;
        }
        self.leftBtn.selected = YES;
    }else if(self.index==self.urlArr1.count-1){
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;

    }else{
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
    }
}
-(void)menuBtnClicked{
    if (self.urlStr.length>0) {
        //分享的url
        NSURL *urlToShare = [NSURL URLWithString:self.urlStr];
        
        NSArray *activityItems = @[urlToShare];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
        //分享之后的回调
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed) {
                NSLog(@"completed");
                //分享 成功
            } else  {
                NSLog(@"cancled");
                //分享 取消
            }
        };
    }
    
}
-(void)refreshBtnClicked{
    self.isrefresh = YES;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.wkWebView loadRequest:request];
}
-(BOOL)ChanrgeCanCollect{
    if ([self.urlStr containsString:@"google"]||[self.urlStr containsString:@"youtube"]||[self.urlStr containsString:@"twitter"]||[self.urlStr isEqualToString:@"https://www.bing.com/"]) {
        return NO;
    }
    return YES;
}
#pragma mark - 键盘处理
- (void)keyboardWillShow:(NSNotification *)note {
    kViewBorderRadius(_searchBar, 8, 1, [UIColor colorWithHexString:@"#E7D4FF"]);
    _searchBar.width = kScreenW - 130;
    self.cancleBtn.hidden = NO;
    self.collectBtn.hidden = YES;

}

- (void)keyboardWillHide:(NSNotification *)note {
    kViewBorderRadius(self.searchBar, 8, 0, kClearColor);
    _searchBar.width = kScreenW - 100;
    self.cancleBtn.hidden = YES;
    self.collectBtn.hidden = NO;

}
-(BOOL)isnet:(NSString *) content{
    if ([content hasSuffix:@".com"]||
        [content hasSuffix:@".org"]||
        [content hasSuffix:@".net"]||
        [content hasSuffix:@".gov"]||
        [content hasSuffix:@".edu"]||
        [content hasSuffix:@".io"]||
        [content hasSuffix:@".co"]||
        [content hasSuffix:@".info"]||
        [content hasSuffix:@".biz"]||
        [content hasSuffix:@".me"]||
        [content hasSuffix:@".online"]||
        [content hasSuffix:@".store"]||
        [content hasSuffix:@".us"]||
        [content hasSuffix:@".uk"]||
        [content hasSuffix:@".ca"]||
        [content hasSuffix:@".au"]||
        [content hasSuffix:@".de"]||
        [content hasSuffix:@".fr"]||
        [content hasSuffix:@".in"]||
        [content hasSuffix:@".ch"]||
        [content hasSuffix:@".br"]||
        [content hasSuffix:@".mx"]||
        [content hasSuffix:@".hk"]||
        [content hasSuffix:@".blog"]||
        [content hasSuffix:@".app"]||
        [content hasSuffix:@".design"]||
        [content hasSuffix:@".guru"]||
        [content hasSuffix:@".agency"]||
        [content hasSuffix:@".world"]||
        [content hasSuffix:@".events"]||
        [content hasSuffix:@".page"]||
        [content hasSuffix:@".space"]||
        [content hasSuffix:@".music"]) {
        return YES;
    }
    return NO;
}
-(NSString *)urlDesign: (NSString *)url{
    if ([self isnet:url]) {
        if([url hasPrefix:@"https://"]||[url hasPrefix:@"http://"]){
            return url;
        }else if ([url hasPrefix:@"www."]){
            return kStringFormat(@"https://%@",url);
        }else{
            return kStringFormat(@"https://www.%@",url);
        }
    }else{
        return kStringFormat(@"https://www.cn.bing.com/search?q=%@",url);
    }
}
@end
