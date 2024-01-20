//
//  ACWebClickerDetailChooseV.m
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/10/31.
//

#import "ACWebClickerDetailChooseV.h"
#import "LiuXSlider.h"
#import "NumberCalculate.h"
#import "ACWebClikerDChooseTBCell.h"
@interface ACWebClickerDetailChooseV()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NumberCalculate *number;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger numberValue;

@property (nonatomic, strong) UIView *bgView;


@end

@implementation ACWebClickerDetailChooseV
-(NSMutableArray *)delayTimeArr{LazyMutableArray(_delayTimeArr)};
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = kRGBA(0, 0, 0, 0.3);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [self addGestureRecognizer:tap];
        self.repeatNum = 10;
        self.numberValue = 3;
        [self.delayTimeArr addObjectsFromArray:@[@0,@0,@0]];
        [self setUI];
        [kNotificationCenter addObserver:self selector:@selector(changeArrValue:) name:@"cellChangeValue" object:nil];
    }
    return self;
}
-(void)closeView{
    if(self.closeAction){
        self.closeAction();
    }
}
-(void)hiddenView{
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.bgView.y = kScreenH;
//
//    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.y = kScreenH;
    } completion:^(BOOL finished) {
        self.hidden = true;
    }];
}
-(void)showView{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.y = 0;
//    }];
    self.hidden = false;

    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.y = kNavBarHeight+140;
    } completion:^(BOOL finished) {
    }];
}
-(void)setUI{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+140, kScreenW, kScreenH-kNavBarHeight-140)];
    bgview.backgroundColor = UIColor.mainBlackColor;
    self.bgView = bgview;
    [self addSubview:bgview];
    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i<=300; i++) {
        [valueArr addObject:kStringFormat(@"%i",i)];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [bgview addGestureRecognizer:tap];
    kWeakSelf(self);
    UILabel *nameLabel = [bgview createLabelTextColor:kWhiteColor font:kFont(14)];
    nameLabel.text = KLanguage(@"repeat times:");
    nameLabel.frame = CGRectMake(16, 26, 200, 12);
    
    LiuXSlider *slider=[[LiuXSlider alloc] initWithFrame:CGRectMake(10, 50, kScreenW-20, 50) titles:valueArr firstAndLastTitles:@[@"1",@"300"] defaultIndex:9 sliderImage:[UIImage imageNamed:@"slider_yuan"]];
    [bgview addSubview:slider];
    
    slider.block=^(int index){
        weakself.repeatNum = index+1;

    };
    
    
    UILabel *nameLabel1 = [bgview createLabelTextColor:kWhiteColor font:kFont(14)];
    nameLabel1.text = KLanguage(@"number of Taps");
    nameLabel1.frame = CGRectMake(16, 140, 200, 12);
    
    _number=[[NumberCalculate alloc]initWithFrame:CGRectMake(kScreenW-130, 130, 115, 30)];
    _number.showNum=3;
    _number.minNum=1;
    _number.maxNum=10;//最大值
    _number.backgroundColor = UIColor.mainBlackColor;
    kViewRadius(_number, 5);
    [bgview addSubview:_number];
    _number.resultNumber = ^(NSInteger number) {
        weakself.numberValue = number;
        [weakself.tableView reloadData];
        if(self.delayTimeArr.count>number){
            [weakself.delayTimeArr removeObjectsInRange:NSMakeRange(number, self.delayTimeArr.count-number)];
            
        }else if(self.delayTimeArr.count<number){
            for (int i = 0; i<number-self.delayTimeArr.count; i++) {
                [weakself.delayTimeArr addObject:@(0)];
            }
        }
        if(weakself.countChangeBlock){
            weakself.countChangeBlock();
        }
    };
    
    [bgview addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(nameLabel1.mas_bottom).mas_offset(12);
        make.bottom.mas_equalTo(bgview.mas_bottom).mas_offset(-10);
    }];
}
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.mainBlackColor;
        _tableView.rowHeight = 150;
        [_tableView registerNib:[UINib nibWithNibName:@"ACWebClikerDChooseTBCell" bundle:nil] forCellReuseIdentifier:@"ACWebClikerDChooseTBCell"];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberValue;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ACWebClikerDChooseTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ACWebClikerDChooseTBCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tapNameL.text = kStringFormat(@"%@ %li",KLanguage(@"Tap"),(long)indexPath.row+1);
    cell.delayNoticeL.text = KLanguage(@"delay time");
    cell.tag = indexPath.row +1000;
    NSInteger index = [self.delayTimeArr[indexPath.row] intValue];
    [cell refreshSliderwithValue:index];
    return cell;
}
-(void)action{
    
}
-(void)changeArrValue:(NSNotification *)sender{
    NSDictionary  *dic = sender.userInfo;
    NSInteger row = [dic[@"index"] intValue];
    NSInteger value = [dic[@"value"] intValue];
    [self.delayTimeArr replaceObjectAtIndex:row withObject:@(value)];

}
@end
