//
//  GDHAccountBalanceViewController.m
//  Wallet
//
//  Created by GDH on 15/10/22.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "GDHAccountBalanceViewController.h"
#import "GDHAccountTableViewCell.h"
#import "GDHPayInHome.h"
#import "GCUtil.h"
#import "CJHelpViewController.h"
#import "GDHBalanceDetailModel.h"
#import "GDHRsModel.h"
#import "MJRefresh.h"
#import "LaoYiLaoViewController.h"
#import "GDHNoMoneyView.h"
@interface GDHAccountBalanceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    /** 收入支出 视图 */
    GDHPayInHome *_payInHome;
    /** 判断 是否选择收入支出按钮 */
    BOOL _thePayInHome;
    /** 没有余额明细 */
    GDHNoMoneyView *noMoneyView;
    //上提加载
    MJRefreshFooterView        *_footer;
    //上提加载
    MJRefreshHeaderView        *_header;


}
@property(nonatomic,strong)NSMutableArray *dataArray;
/** 页数 */
@property (nonatomic, assign) int page;
/** 每页请求的数量 */
@property (nonatomic, assign) int count;
/** 总页数 */
@property (nonatomic, copy) NSString *totalCount;

/** 类型： 1 支付，0 收入 */
@property (nonatomic,copy) NSString * amountType;

@property(nonatomic,strong)GDHPayInHome *payInHome;
/** 没有数据的页面View */
@property (nonatomic, strong) UIView *noRecordView;

@end

@implementation GDHAccountBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _thePayInHome = NO;
    self.page = 1;
    self.count = 20;
    self.amountType = @"";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 64, ScreenWidth, 30);
    button.backgroundColor = WalletHomeHeadGRD;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:AccountBalanceTitle forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(LYLButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(accountBalance:) forControlEvents:UIControlEventTouchUpInside];
    [self makeNav];
    [self makeTableView];
    [self payIncome];
    [self NOMoney];
    [self request1002getAccountBalanceDetail];
}
#pragma  mark - 捞一捞

-(void)accountBalance:(UIButton *)account{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popLYLVC" object:@"-1"];
    for (UIViewController *subVC in self.navigationController.viewControllers) {
        if([subVC isKindOfClass:[LaoYiLaoViewController class]]){
            [self.navigationController popToViewController:subVC animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteItem" object:nil];
            return;
        }
    }
    
        LaoYiLaoViewController *laoYILao = [[LaoYiLaoViewController alloc]init];
        
        NSDictionary *dic = kkNickDicJava;
        if ([[dic objectForKey:@"id"] intValue] < 2) {
            laoYILao.userID = @"";
            laoYILao.phone = @"";
        }else{
            laoYILao.userID = kkUserCenterId;
            laoYILao.phone = kkUserName;        }
        [self.navigationController pushViewController:laoYILao animated:YES];
    
}
/** 1002获取余额明细列表网络请求 */
-(void)request1002getAccountBalanceDetail {
    
    [self chrysanthemumOpen];
    noMoneyView.hidden =  YES;
    NSDictionary *dict = [WalletRequsetHttp WalletPersonAccountBalanceList1002AmountType:self.amountType andpage:[NSString stringWithFormat:@"%d",self.page ]andCount:[NSString stringWithFormat:@"%d",self.count ]];
    NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_BalanceDetail,[dict JSONFragment]];
    [SINOAFNetWorking postWithBaseURL:url controller:self success:^(id json) {
        
        [self removeDataArrayThePageOne];
     
        NSDictionary *dict = json;
        if ([dict[@"code"] isEqualToString:@"100"]) {
            NSArray *rsArray = dict[@"rs"];
            self.totalCount = dict[@"num"];//总页数
            
            if (rsArray.count) {
                for (NSDictionary *dic in rsArray) {
                    GDHRsModel *model = [[GDHRsModel alloc] initWithDic:dic];
                    [self.dataArray addObject:model];
                }
                [_tableView reloadData];
            }else{
                // 当没有数据时显示没有余额
                [self showMsg:ShowNoMessage];
            }
            [self endRefresh];
            [self JudgeTheDataArrayIFNULL];// 判断显示数据为空，来显示隐藏noMoneyView
        }
        [self chrysanthemumClosed];
    } failure:^(NSError *error) {
        [self showMsg:ShowMessage];
        [self chrysanthemumClosed];
        [self endRefresh];
    } noNet:^{
        [self chrysanthemumClosed];
        [self endRefresh];
    }];
}
/** 当self.page == 1 时 清空数据源 */
-(void)removeDataArrayThePageOne{
    if ([[NSString stringWithFormat:@"%d",self.page] isEqualToString:@"1"]) {
        [self.dataArray removeAllObjects];
    }
}
/** 判断数据是否为空 */
-(void)JudgeTheDataArrayIFNULL{
    if (self.dataArray.count > 0) {
        noMoneyView.hidden = YES;
    }else{
        [_tableView reloadData];
        noMoneyView.hidden = NO;
    }
}
/** 没有余额明细 */
- (void)NOMoney{
    
    noMoneyView = [[GDHNoMoneyView alloc] initWithFrame:CGRectMake(0, 94, ScreenWidth, ScreenHeight - 94)];
    noMoneyView.hidden = YES;
    __weak GDHAccountBalanceViewController*temp =self;
    noMoneyView.block = ^(UIButton *button){
        [temp helpButtonDown:button];
    };
    [self.view addSubview:noMoneyView];
}
/** 帮助 */
-(void)helpButtonDown:(UIButton *)helpButton{
    CJHelpViewController *helpVC = [[CJHelpViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma  mark - 收入 支出
/** 支出收入 */
-(void)payIncome{
    __weak GDHAccountBalanceViewController*temp = self;
    _payInHome = [[GDHPayInHome alloc] initWithFrame:CGRectMake(ScreenWidth - 15-79, 44, 79, 58)];
    _payInHome.layer.borderWidth = 0.5;
    _payInHome.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _payInHome.payBlock = ^(UIButton *pay){
        [temp useMoney];
        NSLog(@"支付");
        //支付
    };
    _payInHome.inHomeBlock = ^(UIButton *inHome){
               NSLog(@"收入");
        [temp getMoney];
        // 收入
    };
    _payInHome.backgroundColor = [UIColor whiteColor];
    _payInHome.hidden = YES;
    [self.view addSubview:_payInHome];
}

/**  支付 */
-(void)useMoney{
    [self.dataArray removeAllObjects];
    self.amountType = @"1";
    self.page = 1;
    [self request1002getAccountBalanceDetail];
    self.payInHome.hidden = YES;
    _thePayInHome = !_thePayInHome;
}

/**  s收入 */
-(void)getMoney{
    [self.dataArray removeAllObjects];
    self.amountType =@"0";
    self.page = 1;
    [self request1002getAccountBalanceDetail];
    self.payInHome.hidden = YES;
    _thePayInHome = !_thePayInHome;
}
#pragma mark - 设置导航
/** 设置导航 */
-(void)makeNav{
//    self.backView.backgroundColor = WalletHomeNAVGRD
    self.mallTitleLabel.text  = @"余额明细";
//    self.mallTitleLabel.textColor = [UIColor whiteColor];
//    self.mallTitleLabel.font = WalletHomeNAVTitleFont
    [self.rightButton setImage:[UIImage imageNamed:@"content_spanner_more"] forState:UIControlStateNormal];
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
//    [self.leftBackButton setImage:[UIImage imageNamed:@"title_btn_back"] forState:UIControlStateNormal];
    mainView.backgroundColor = [UIColor whiteColor];
}

/** 右侧按钮点击事件 */
-(void)rightBackCliked{
    
    _thePayInHome = !_thePayInHome;
    if (_thePayInHome) {
        _payInHome.hidden = NO;
    }else{
        _payInHome.hidden = YES;
    }
//    _payInHome.hidden = NO;
    
}
#pragma  mark  - tableview
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)makeTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+30, ScreenWidth, ScreenHeight - 94) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.view addSubview:_tableView];
    //添加下拉刷新
    [self addHeadRefresh];
    [self addFootRefresh];
}
/**  下拉 */
-(void)addHeadRefresh{
    
    
    MJRefreshHeaderView  * header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.beginRefreshingBlock = ^ (MJRefreshBaseView * refreshView){
        //  后台执行：
//        [self requestHeader];
        self.page = 1;
        [self request1002getAccountBalanceDetail];
        
    };
    _header = header;
//    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        self.page = 1;
//        [_tableView.header endRefreshing];
//        [self request1002getAccountBalanceDetail];
//    }];
}
/** 上拉 */
- (void)addFootRefresh{
//
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //  后台执行：
        self.page++;
        if ([self.totalCount intValue] >= self.page) {
            [self request1002getAccountBalanceDetail];

        } else {
            [self endRefresh];
            [self showMsg:showMessageNOData];
        }
    };
    _footer = footer;
//    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.page++;
//        if ([self.totalCount intValue] >= self.page) {
//            [_tableView.footer endRefreshing];
//            [self request1002getAccountBalanceDetail];
//
//        } else {
//            [_tableView.footer endRefreshing];
//            _tableView.footer.hidden = YES;
//            [self showMsg:showMessageNOData];
//        }
//    }];
}

-(void)endRefresh{
    [_footer endRefreshing];
    [_header endRefreshing];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDHAccountTableViewCell *accountCell = [GDHAccountTableViewCell cellWithTableView:tableView];
    [accountCell refreshAccount:(GDHRsModel *)self.dataArray[indexPath.row]];
    return accountCell;
}

- (void)dealloc
{
    [self chrysanthemumClosed];
}

@end
