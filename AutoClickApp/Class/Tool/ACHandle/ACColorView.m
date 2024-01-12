//
//  ACColorView.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/8.
//

#import "ACColorView.h"
#import "ACColorItem.h"

@interface ACColorView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, strong) UICollectionView *collectView1;

@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, strong) NSArray *colorArr1;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger selectIndex1;

@end

@implementation ACColorView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    self.selectIndex = 0;
    self.selectIndex1 = 0;
    self.colorArr = @[@"#FFFFFF",
                      @"#FA5151",
                      @"#FF8F1F",
                      @"#FFC300",
                      @"#00B578",
                      @"#07B9B9",
                      @"#3662EC",
                      @"#8A38F5",
                      @"#EB2F96"];
    self.colorArr1 = @[@"#110C10",
                      @"#FCDBDB",
                      @"#FFE5CC",
                      @"#FFF8C6",
                      @"#CFFEEE",
                      @"#C7F5F5",
                      @"#CDE1FD",
                      @"#E7D4FF",
                      @"#FFD7ED"];
    
    UIButton *backBtn = [UIButton buttonWithType:0];
    backBtn.frame = CGRectMake(11, 11, 42, 42);
    [backBtn setImage:kIMAGE_Name(@"handle_down") forState:0];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [backBtn addTarget:self action:@selector(downkAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UILabel *label = [self createLabelFrame:CGRectMake(16, 60, 190, 20) textColor:kWhiteColor font:kFont(14)];
    label.text = KLanguage(@"font color");
    
    UILabel *label1 = [self createLabelFrame:CGRectMake(16, 136, 190, 20) textColor:kWhiteColor font:kFont(14)];
    label1.text = KLanguage(@"background color");
    
    [self addSubview:self.collectView];
    [self addSubview:self.collectView1];
}
-(void)downkAction{
    //[playVolume playMusic];

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, kScreenH, self.frame.size.width, self.frame.size.height);
    }];
}
-(UICollectionView *)collectView{
    if(!_collectView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 88, kScreenW-32, 42) collectionViewLayout:layout];
        _collectView.tag = 1;
        _collectView.delegate = self;
        _collectView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectView.backgroundColor = UIColor.clearColor;
        _collectView.showsVerticalScrollIndicator = false;
        _collectView.showsHorizontalScrollIndicator = false;
        _collectView.dataSource = self;
        [_collectView registerNib:[UINib nibWithNibName:@"ACColorItem" bundle:nil] forCellWithReuseIdentifier:@"ACColorItem"];
    }
    return _collectView;
}

-(UICollectionView *)collectView1{
    if(!_collectView1){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        _collectView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 164, kScreenW-32, 42) collectionViewLayout:layout];
        
        _collectView1.tag = 2;
        _collectView1.delegate = self;
        _collectView1.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectView1.backgroundColor = UIColor.clearColor;
        _collectView1.showsVerticalScrollIndicator = false;
        _collectView1.showsHorizontalScrollIndicator = false;
        _collectView1.dataSource = self;
        [_collectView1 registerNib:[UINib nibWithNibName:@"ACColorItem" bundle:nil] forCellWithReuseIdentifier:@"ACColorItem"];
    }
    return _collectView1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        ACColorItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACColorItem" forIndexPath:indexPath];
        item.backgroundColor = [UIColor colorWithHexString:self.colorArr[indexPath.row]];
        kViewBorderRadius(item, 4, 2, [UIColor colorWithHexString:@"#333333"]);
        if (self.selectIndex==indexPath.row) {
            kViewBorderRadius(item, 4, 2, [UIColor colorWithHexString:@"#8A38F5"]);
        }
        return item;
    }else{
        ACColorItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACColorItem" forIndexPath:indexPath];
        item.backgroundColor = [UIColor colorWithHexString:self.colorArr1[indexPath.row]];
        kViewBorderRadius(item, 4, 2, [UIColor colorWithHexString:@"#333333"]);
        if (self.selectIndex1==indexPath.row) {
            kViewBorderRadius(item, 4, 2, [UIColor colorWithHexString:@"#8A38F5"]);
        }
        return item;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    NSArray * arr = self.colorArr;
    if (collectionView.tag == 1) {
        self.selectIndex = indexPath.row;
    }else{
        self.selectIndex1 = indexPath.row;
        arr = self.colorArr1;
    }
    [collectionView reloadData];
    if(self.selectColorBlock){
        self.selectColorBlock(collectionView.tag, arr[indexPath.row]);
    }
}
@end
