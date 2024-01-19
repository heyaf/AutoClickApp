//
//  ACWebClickerDetailVC.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/30.
//

#import "ACWebClickerDetailVC.h"
#import <WebKit/WebKit.h>
//#import <PTFakeTouch.h>
#import "ACWebClickerDetailChooseV.h"
#import "WMDragView.h"
#import "RoundAnimationButton.h"
#import "UIView+hite.h"
@interface ACWebClickerDetailVC ()<WKNavigationDelegate,UISearchBarDelegate>{
    dispatch_source_t timer;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic ,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UILabel *urlLabel;

@property (nonatomic, strong) UIView *bottmView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, assign) NSInteger index; //当前是在第几个页面
//是否是返回上一级
@property (nonatomic, assign) BOOL isback;
@property (nonatomic, assign) BOOL isRightClicked;
@property (nonatomic, assign) BOOL isrefresh;
@property (nonatomic, assign) BOOL isstop; //是否停止点击，防止用户快速的点击开始-关闭，导致的崩溃

@property (nonatomic, strong) ACWebClickerDetailChooseV *chooseV;

@property (nonatomic, strong) NSMutableArray *dragViewArr; //拖拽数组

@property (nonatomic, assign) NSInteger countNum;

@property (nonatomic, strong) RoundAnimationButton *startBtn;
@property (nonatomic, strong) UIImageView *startImageV;

@property (nonatomic, strong) UIView *lineV;

@end

@implementation ACWebClickerDetailVC

-(NSMutableArray *)urlArr{LazyMutableArray(_urlArr)}
-(NSMutableArray *)dragViewArr{LazyMutableArray(_dragViewArr)}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.mainBlackColor;
    [self.view addSubview:self.wkWebView];

    NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];

    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        self.progressView.backgroundColor = [UIColor clearColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    self.progressView.progressTintColor = [UIColor colorWithHexString:@"#8A38F5"];
        [self.wkWebView addSubview:self.progressView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    [self.view addSubview:self.topV];
    [self.view addSubview:self.bottmView];
    [self.view addSubview:self.chooseV];

    [self addDragView];
    self.index = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (![vipTool isVip]) {
        [self vipBtnAction];
    }
}

-(void)addDragView{
    CGFloat w = 51;
    CGFloat h = 48;
    
    CGFloat marginW = (kScreenW- 51*5)/6;
    
    for (int i=1; i<=10; i++) {
        
        CGFloat hang = (i-1)/5;
        CGFloat lie = (i-1)%5;
        
        WMDragView *dragV = [[WMDragView alloc] initWithFrame:CGRectMake(marginW + (marginW+w)*lie, kNavBarHeight+marginW*2+(marginW+h)*hang, w, h)];
        [dragV.button setBackgroundImage:kIMAGE_Name(kStringFormat(@"drag%i",i)) forState:0];
        dragV.tag = 200+i;
        
        dragV.backgroundColor = kClearColor;
        [self.wkWebView addSubview:dragV];
        dragV.hidden = YES;
        [self.dragViewArr addObject:dragV];
        if(i<=3){
            dragV.hidden = NO;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
-(void)vipBtnAction{
    ACPayTwoViewController *vc = [ACPayTwoViewController new];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.reloadVip = ^{
    };
    [self presentViewController:vc animated:YES completion:nil];
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
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
       
        _wkWebView.navigationDelegate = self;
        
    }
    return _wkWebView;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
   
    // 获取url
    NSURLRequest * request = navigationAction.request;
    NSString * requestStr = request.URL.absoluteString;
    NSLog(@"URL:%@",requestStr);
    self.searchBar.searchTextField.text = requestStr;
    if (self.isrefresh) {
        self.isrefresh = false;
    }else if(self.isRightClicked){
        self.isRightClicked = NO;
    }else{
        if(self.isback){
            self.isback = NO;
        } else{
            self.index = self.urlArr.count;
            [self.urlArr addObject:requestStr];

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
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    // 网页加载完成后，执行JavaScript模拟点击
       NSString *jsCode = @"var element = document.elementFromPoint(x, y); element.click();";
       NSString *jsFunction = [NSString stringWithFormat:@"function simulateClick(x, y) { %@ }", jsCode];
       [webView evaluateJavaScript:jsFunction completionHandler:nil];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
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
        
        UIView *searchBgv = [[UIView alloc] initWithFrame:CGRectMake(50, kStatusBarHeight+4, kScreenW-66, 36)];
        kViewRadius(searchBgv, 8);
        [_topV addSubview:searchBgv];
        searchBgv.backgroundColor = [UIColor colorWithHexString:@"#272226"];
        
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 16, 16)];
        imageV.image = kIMAGE_Name(@"search_d");
        [searchBgv addSubview:imageV];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBgv.width, 36)];
        _searchBar.placeholder = KLanguage(@"Search Any Website");
        _searchBar.tintColor = kWhiteColor;
        _searchBar.barTintColor = UIColor.color333333;
        _searchBar.searchTextField.textColor = kWhiteColor;
        [_searchBar setImage:kIMAGE_Name(@"search_icon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchBar.searchTextField.backgroundColor = kClearColor;
//        _searchBar.searchTextPositionAdjustment = UIOffsetMake(10, 10);
//        _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(5, 5);
        [searchBgv addSubview:_searchBar];
        _searchBar.delegate = self;
        _searchBar.searchTextField.text = self.urlStr;
        UITextField *textfield;
        if (@available(iOS 13.0, *)) {
            textfield = [_searchBar searchTextField];
        } else {
            textfield = [_searchBar valueForKey:@"_searchField"];
        }
        _searchBar.searchTextField.borderStyle = UITextBorderStyleNone;
 
        //修改placeHolder的颜色
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:KLanguage(@"Search Any Website") attributes:@{NSForegroundColorAttributeName : kRGBA(255, 255, 255, 0.7)}];
        textfield.attributedPlaceholder = placeholderString;
         [_topV createLineFrame:CGRectMake(0, kNavBarHeight-1, kScreenW, 1) lineColor:kRGB(32, 32, 32)];
        
    }
    return _topV;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *str = searchBar.searchTextField.text;
    if(str.length==0){
        return;
    }
    kViewBorderRadius(_searchBar, 8, 1, [UIColor clearColor]);

    if([str hasPrefix:@"https://"]||[str hasPrefix:@"http://"]){
        
    }else if ([str hasPrefix:@"www."]){
        str = kStringFormat(@"https://%@",str);
    }else{
        str = kStringFormat(@"https://www.cn.bing.com/search?q=%@",str);
        
    }
    self.urlStr = str;
    NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    kViewBorderRadius(_searchBar, 8, 1, [UIColor colorWithHexString:@"#E7D4FF"]);

}
-(UIView *)bottmView{
    if(!_bottmView){
        _bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-kTabBarHeight, kScreenW, kTabBarHeight)];
        _bottmView.backgroundColor = [UIColor mainBlackColor];
        
        RoundAnimationButton *starBtn = [RoundAnimationButton buttonWithType:0];
        starBtn.frame = CGRectMake(0, 7, 112, 36);
        starBtn.centerX = kScreenW/2;
        [_bottmView addSubview:starBtn];
        [starBtn setImage:kIMAGE_Name(@"clicked") forState:0];
        [starBtn setImage:kIMAGE_Name(@"drag01") forState:UIControlStateSelected];
        [starBtn setTitle:KLanguage(@"Start clicking") forState:0];
        [starBtn setTitle:KLanguage(@"stop clicking") forState:UIControlStateSelected];

        starBtn.titleLabel.font = kFont(10);
        [starBtn setTitleColor:[UIColor mainBlackColor] forState:0];
        [starBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [starBtn setBackgroundColor:kWhiteColor];
        kViewRadius(starBtn, 18);
        [starBtn addTarget:self action:@selector(starClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.startBtn = starBtn;
        CGFloat marginL = (kScreenW-36-32-24*4)/4;
        
        UIButton *leftBtn = [UIButton buttonWithType:0];
        leftBtn.frame = CGRectMake(16, 10, 24, 24);
        [_bottmView addSubview:leftBtn];
        [leftBtn setImage:kIMAGE_Name(@"backright") forState:0];
        [leftBtn setImage:kIMAGE_Name(@"backright_un") forState:UIControlStateSelected];

        [leftBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [UIButton buttonWithType:0];
        rightBtn.frame = CGRectMake(16+14+marginL, 10, 24, 24);
        [_bottmView addSubview:rightBtn];
        [rightBtn setImage:kIMAGE_Name(@"goright") forState:0];
        [rightBtn setImage:kIMAGE_Name(@"goright_an") forState:UIControlStateSelected];

        [rightBtn addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftBtn = leftBtn;
        self.rightBtn = rightBtn;
        UIButton *menuBtn = [UIButton buttonWithType:0];
        menuBtn.frame = CGRectMake(kScreenW/2+28+marginL, 10, 24, 24);
        [_bottmView addSubview:menuBtn];
        [menuBtn setImage:kIMAGE_Name(@"menu") forState:0];
        [menuBtn addTarget:self action:@selector(menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *refreshBtn = [UIButton buttonWithType:0];
        refreshBtn.frame = CGRectMake(kScreenW/2+18+marginL*2+24, 10, 24, 24);
        [_bottmView addSubview:refreshBtn];
        [refreshBtn setImage:kIMAGE_Name(@"refresh") forState:0];
        [refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottmView;
}
-(void)backAction{
    //[playVolume playMusic];

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshButtonStatues{
    if(self.index==0){
        if(self.urlArr.count>1){
            self.rightBtn.selected = NO;
        }else{
            self.rightBtn.selected = YES;
        }
        self.leftBtn.selected = YES;
    }else if(self.index==self.urlArr.count-1){
        self.leftBtn.selected = NO;
        self.rightBtn.selected = YES;

    }else{
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
    }
}
-(void)starClicked:(RoundAnimationButton *)startBtn{
    
    if(startBtn.isSelected){
        if(self->timer){
            dispatch_cancel(self->timer);
            self->timer = nil;
        }
        self.isstop = YES;

        [startBtn hiddenAnnimation];
        self.startImageV.hidden = YES;
        [startBtn setBackgroundColor:kWhiteColor];
        startBtn.selected = NO;
        return;
    }
    self.isstop = NO;
    //[playVolume playMusic];

    startBtn.selected = YES;
    [startBtn showAnnimation];
    [startBtn setBackgroundColor:[UIColor colorWithHexString:@"#FA5151"]];
    [self.chooseV hiddenView];
    
    NSInteger count = self.chooseV.delayTimeArr.count;
//    CGFloat delayTimer
    UIView *view = self.dragViewArr[0];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(view.x-2, view.y-2, view.width+4, view.height+4)];
    imageV.image = kIMAGE_Name(@"drag99");
    self.startImageV = imageV;
    [self.wkWebView addSubview:imageV];
    view.hidden = YES;
    [UIView animateWithDuration:.1 animations:^{
        [imageV.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
  
        CGFloat x = imageV.centerX-23;
        CGFloat y = imageV.centerY-22;
       
        NSString *jsCall = [NSString stringWithFormat:@"simulateClick(%f, %f);", x, y];
        [self.wkWebView evaluateJavaScript:jsCall completionHandler:nil];
        [playVolume playMusic];
        [UIView animateWithDuration:.1 animations:^{
            [imageV.layer setValue:@(0.8) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 animations:^{
                [imageV.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    view.hidden = NO;
                });

            }];
        }];
    }];
    NSInteger firstDelay = [self.chooseV.delayTimeArr[0] integerValue]/2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *delayArr = [NSMutableArray arrayWithCapacity:0];
        NSInteger delayValue = 0;
//        [delayArr addObject:@(0)];

        for (int i =0 ; i<count; i++) {
            NSInteger delayTime = [self->_chooseV.delayTimeArr[i] intValue]+1;
            delayValue = delayTime + delayValue;
            [delayArr addObject:@(delayValue)];
        }

        self->_countNum = 0;
        //在当前循环的第几个元素
        __block NSInteger moveCount = 0;
        __block NSInteger repleatCount = 1;

        kWeakSelf(self);
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self->timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
        dispatch_source_set_timer(self->timer, dispatch_walltime(NULL, 0), 0.5*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self->timer, ^{
            if(self.isstop){
                if(self->timer){ //防止快速点击开始-关闭导致的崩溃
                    dispatch_cancel(self->timer);
                    self->timer = nil;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageV removeFromSuperview];
                    [startBtn setBackgroundColor:kWhiteColor];
                    startBtn.selected = NO;
                    [startBtn hiddenAnnimation];
                });
            }

                if([delayArr containsObject:@(self->_countNum)]){
                    moveCount++;
                    if(moveCount>=count){
                        repleatCount++;
                        moveCount=0;
                        self->_countNum = 0;
                        if(repleatCount-1==weakself.chooseV.repeatNum){
                            dispatch_cancel(self->timer);
                            self->timer = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [imageV removeFromSuperview];
                                [startBtn setBackgroundColor:kWhiteColor];
                                startBtn.selected = NO;
                                [startBtn hiddenAnnimation];
                            });

                            return;
                        }else{
                           
                        }
                        
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{

                        UIView *view = weakself.dragViewArr[moveCount];
                        view.hidden = YES;
                        [UIView animateWithDuration:0.1 animations:^{
                            imageV.frame = CGRectMake(view.x-2, view.y-2, view.width+4, view.height+4);
                        } completion:^(BOOL finished) {
                            CGFloat x = imageV.centerX-23;
                            CGFloat y = imageV.centerY-22;
                           
                            NSString *jsCall = [NSString stringWithFormat:@"simulateClick(%f, %f);", x, y];
                            [self.wkWebView evaluateJavaScript:jsCall completionHandler:nil];
                            [playVolume playMusic];
                            [UIView animateWithDuration:.1 animations:^{
                                [imageV.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:.1 animations:^{
                                    [imageV.layer setValue:@(0.8) forKeyPath:@"transform.scale"];
                                } completion:^(BOOL finished) {
                                    [UIView animateWithDuration:.1 animations:^{
                                        [imageV.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                                    } completion:^(BOOL finished) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            view.hidden = NO;
                                        });

                                    }];
                                }];
                            }];
                        }];
                        
                    });
                    
                }else{
                    NSLog(@"不执行");
                }
           
            self->_countNum++;
            NSLog(@"num----%li",(long)self->_countNum);
        });
        
        dispatch_resume(self->timer);
    });

    

    
 
}
-(void)leftClicked{
    //[playVolume playMusic];

    if(self.index>0&&self.urlArr.count>1){
        self.isback = YES;
        self.index--;
        NSString *url = [self.urlArr objectAtIndex:self.index];
        self.urlStr = url;
        NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url2 = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url2];
        [self.wkWebView loadRequest:request];
        self.urlLabel.text = url;
    }
}
-(void)rightClicked{
    //[playVolume playMusic];

    if(self.index<self.urlArr.count-1&&self.urlArr.count>1){
        self.isRightClicked = YES;
        self.index++;
        NSString *url = [self.urlArr objectAtIndex:self.index];
        self.urlStr = url;
        NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

        NSURL *url2 = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url2];
        [self.wkWebView loadRequest:request];
        self.urlLabel.text = url;
    }
}
-(void)menuBtnClicked{
    //[playVolume playMusic];

    if(self.startBtn.isSelected){
        return;
    }
    [self.chooseV showView];
}
-(ACWebClickerDetailChooseV *)chooseV{
    if(!_chooseV){
        _chooseV = [[ACWebClickerDetailChooseV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTabBarHeight)];
        [_chooseV hiddenView];
//        kWeakSelf(_chooseV);
//        _chooseV.closeAction = ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                weak_chooseV.y = kScreenH;
//            }];
//        };
        kWeakSelf(self);
        _chooseV.countChangeBlock = ^{
            [weakself refreshDragData];
        };
    }
    return _chooseV;
}
-(void)refreshDragData{
    NSInteger count = self.chooseV.delayTimeArr.count;
    
    for (UIView *dragView in self.dragViewArr) {
        dragView.hidden = dragView.tag-200>count;
    };
}
-(void)refreshBtnClicked{
    //[playVolume playMusic];

    self.isrefresh = YES;
    NSString *encodedString = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(timer){
        dispatch_cancel(self->timer);
        self->timer = nil;
    }

}
- (void)keyboardWillHide:(NSNotification *)note {
    kViewBorderRadius(_searchBar, 8, 1, kClearColor);


}
@end
