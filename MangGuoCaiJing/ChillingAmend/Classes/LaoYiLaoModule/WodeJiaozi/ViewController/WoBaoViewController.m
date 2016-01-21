//
//  WoBaoViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
/*
 json  = @{@"put_ price":@"200.00",@"number_ price":@"100",@"resultList":@[
 @{@"dumpling_user_put_money_id":@"001",@"createTime":@"10:21",@"content":@"20个饺子每个5毛，饺子10元，领完10",@"dumplingMoney":@"10.00",@"dumplingNum":@"30",@"getDumplingNum":@"10",@"status":@"1",},
 @{@"dumpling_user_put_money_id":@"002",@"createTime":@"10:22",@"content":@"10个饺子每个2快，饺子20元，领完10",@"dumplingMoney":@"20.00",@"dumplingNum":@"10",@"getDumplingNum":@"10",@"status":@"2",},
 @{@"dumpling_user_put_money_id":@"003",@"createTime":@"10:23",@"content":@"10个饺子每个5快，饺子50元，领完8",@"dumplingMoney":@"30.00",@"dumplingNum":@"50",@"getDumplingNum":@"20",@"status":@"3",},
 @{@"dumpling_user_put_money_id":@"004",@"createTime":@"10:24",@"content":@"恭喜发财,猴年大吉",@"dumplingMoney":@"40.00",@"dumplingNum":@"40",@"getDumplingNum":@"10",@"status":@"1",},
 ]};

*/

#import "WoBaoViewController.h"
#import "WoBaoViewFor.h"
#import "WobaoCashModel.h"
#import "WobaoCashResultModel.h"
#import "LYLaoYiLaoViewController.h"

#import "NewNoDumpView.h"

//#define ScaleForHeight    (kkViewHeight /480.0)


@interface WoBaoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    WoBaoViewFor *_woBaoView;
    UIView  * _labelView;
    UILabel * _label1;
    UILabel * _label2;
    
    
    
    
    int _totalPages;
    int _page;//页
    MJRefreshHeaderView * _header;
    MJRefreshFooterView * _footer;
    NewNoDumpView  * _noBaoJiaoziView;//没有包饺子时显示的view

}
@property (nonatomic, strong) UITableView       * woBaoTableView;
@property (nonatomic, strong) NSMutableArray    * wobaoXianjinDataArray;
@property (nonatomic, strong) NSMutableArray    * middleMutableArray;
@end

@implementation WoBaoViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wobaoXianjinDataArray = [NSMutableArray array];
        self.middleMutableArray = [NSMutableArray array];
        _page = 1;
        [self tableViewSepatorSet];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigation.backgroundColor = BackRedColor;
    [self changeBarTitleWithString:@"包现金"];
    [self addWobaoXianjinView];
    [self addNoBaoJiaoziView];
}

-(void)addNoBaoJiaoziView{
    CGRect baojiaoziFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth,CustomViewHeight);
    _noBaoJiaoziView = [[NewNoDumpView alloc]initWithFrame:baojiaoziFrame];
    _noBaoJiaoziView.hidden = YES;
    [_noBaoJiaoziView showViewWithType:NoTypeBaoJiaozi];
    [self.view addSubview:_noBaoJiaoziView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.totalMoney floatValue] == 0) {
        [self showNoJiaoziView];
    }else{
        [self showBaoJiaoziList];        
        [self loadWobaoXianjinData];
        [_woBaoTableView reloadData];
    }
}

-(void)showNoJiaoziView{
    _labelView.hidden = YES;
    _woBaoTableView.hidden = YES;
    _noBaoJiaoziView.hidden = NO;
}


-(void)showBaoJiaoziList{
    _labelView.hidden = NO;
    _woBaoTableView.hidden = NO;
    _noBaoJiaoziView.hidden = YES;
}


-(void)loadWobaoXianjinData{
    [self showHudInView:self.view hint:@"正在加载"];
     NSString * pageNo = [NSString stringWithFormat:@"%d",_page];
    int size = 10;
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool wobaoXianjinWithSize:[NSString stringWithFormat:@"%d",size] page:pageNo] success:^(id json) {
        [self hideHud];
        ZHLog(@"%@",json);
        
        if ([json[@"code"] isEqualToString:@"100"]) {
             NSArray *arr = json[@"resultList"];
            if (arr.count>0) {
                NSMutableArray * tempMutableArray = [NSMutableArray array];                
                for (int i=0; i<arr.count; i++) {
                    WobaoCashResultModel * model = [WobaoCashResultModel getWobaoCashResultModelWithDic:arr[i]];
                    [tempMutableArray addObject:model];
                }
                
                if (_page == 1) {
                    [self.middleMutableArray removeAllObjects];
                }
                [self.middleMutableArray  addObjectsFromArray:tempMutableArray];
                
                self.wobaoXianjinDataArray = [NSMutableArray arrayWithArray:self.middleMutableArray];
                [self doneWithView:_footer];
                
            }else{
                [self showHint:@"没有更多了"];
                [self doneWithView:_footer];
                UILabel * v = [[UILabel alloc]initWithFrame:CGRectMake(0, 30/2, kkViewWidth, 20)];
                
                v.textAlignment = NSTextAlignmentCenter;
                v.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                v.font = UIFont24;
                UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
                [v addSubview:line];
                v.text = @"没有更多数据...";
            
                [_woBaoTableView setTableFooterView:v];
            }

            [_woBaoTableView reloadData];
        }

    } failure:^(NSError *error) {
       [self hideHud];
    }];
}

#pragma mark MJRefresh
- (void)addRefresh
{
//    _header = [MJRefreshHeaderView header];
//    _header.scrollView = _woBaoTableView;
//    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _woBaoTableView;
    _footer.delegate = self;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer){
        _page ++;
    }else {
        _page = 1;
        [self.wobaoXianjinDataArray removeAllObjects];
    }

    [self loadWobaoXianjinData];
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.5];
}


- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

-(void)tableViewSepatorSet{
    if ([_woBaoTableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [_woBaoTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_woBaoTableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        [_woBaoTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)addWobaoXianjinView{
    
    _woBaoTableView = [[UITableView alloc]init];
    [self.view addSubview:_woBaoTableView];
    
    _labelView = [[UIView alloc]init];
    [self.view addSubview:_labelView];
    
    
    CGFloat labelViewH = 70/2;
    _labelView.frame = CGRectMake(0, NavgationBarHeight, kkViewWidth, labelViewH);
    _labelView.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    CGFloat space   = 20;//label之间的间隔
    CGFloat label_x = 10;
    CGFloat label_w = (kkViewWidth - 2*label_x - space)/2;
    CGFloat label_h = 20;
    CGFloat label_y = (labelViewH-label_h)/2;
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(label_x+space+label_w, label_y, label_w, label_h)];
    [_labelView addSubview:_label1];
    [_labelView addSubview:_label2];
    
    _label1.textAlignment = NSTextAlignmentCenter;
    _label2.textAlignment = NSTextAlignmentCenter;
    
    _label1.backgroundColor = [UIColor clearColor];
    _label2.backgroundColor = [UIColor clearColor];
    _label1.textColor = RGBACOLOR(0, 0, 0, 1);
    _label2.textColor = RGBACOLOR(0, 0, 0, 1);
    
    _label1.text = [NSString stringWithFormat:@"共包%.2f现金",[self.totalMoney floatValue]];
    _label2.text = [NSString stringWithFormat:@"现金饺子%@个",self.totalNumber];
    
    
    CGFloat tableView_Y = CGRectGetMaxY(_labelView.frame);
    _woBaoTableView.frame = CGRectMake(10, tableView_Y, kkViewWidth-2*10, kkViewHeight-tableView_Y);
    _woBaoTableView.delegate = self;
    _woBaoTableView.dataSource = self;
    _woBaoTableView.showsVerticalScrollIndicator = NO;
//    _woBaoTableView.bounces = NO;
    
    _woBaoTableView.hidden = YES;
    _labelView.hidden = YES;
    
    UIView * v = [[UILabel alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor whiteColor];
    [_woBaoTableView setTableFooterView:v];
    
    
    [_woBaoTableView registerClass:[SSWobaoCell class] forCellReuseIdentifier:@"SSWobaoCell"];
    
    [self addRefresh];
    
}
-(void)viewDidLayoutSubviews
{
    if ([_woBaoTableView  respondsToSelector:@selector(setSeparatorInset:)]) {
        [_woBaoTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_woBaoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_woBaoTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{

    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//-(void)showViewWithType:(NSString *)wobaoViewType{
//    if ([wobaoViewType isEqualToString:WoBaoCash]){
//        _label1.text = @"共包100.00现金";
//        _label2.text = @"现金饺子100个";
//    }else if ([wobaoViewType isEqualToString:WoBaoGreetCard]){
//        _label1.text = @"共包200美图";
//        _label2.text = @"贺卡饺子200个";
//    }
//}


#pragma mark TableViewDelegate  &  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wobaoXianjinDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSWobaoCell *cell = [SSWobaoCell cellWithTableView:_woBaoTableView];
    cell.cashResultModel = self.wobaoXianjinDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = (100/2) * ScaleForHeight;
    return rowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
    }
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 70/2;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"row-=%ld",(long)indexPath.row);
    LYLaoYiLaoViewController * vc = [[LYLaoYiLaoViewController alloc]init];
    WobaoCashResultModel * model = self.wobaoXianjinDataArray[indexPath.row];
    if (model.status == 1) {
        vc.dumplingStates = @"4";
    }else if (model.status == 3) {
        vc.dumplingStates = @"1";
    }else if (model.status == 4) {
        vc.dumplingStates = @"2";
    }else if (model.status == 5) {
        vc.dumplingStates = @"3";
    }
    NSLog(@"dumplingStates==%@",vc.dumplingStates);
   vc.dumplingUserPutmoneytid  = model.dumplingUserPutmoneytid;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
