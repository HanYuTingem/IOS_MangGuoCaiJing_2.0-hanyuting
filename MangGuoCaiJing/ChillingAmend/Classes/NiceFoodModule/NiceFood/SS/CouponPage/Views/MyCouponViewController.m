//
//  MyCouponViewController.m
//  QQList
//
//  Created by sunsu on 15/7/2.
//  Copyright (c) 2015年 CarolWang. All rights reserved.
//

#import "MyCouponViewController.h"
#import "CustomActionSheet.h"
#import "DZNSegmentedControl.h"
#import "ProtiketModel.h"
#import "PreferNiceViewCell.h"
#import "CouponDetailViewController.h"
#import "CouponModel.h"
#import "DownLoadData.h"
#import "PreferenTicktcoController.h"
#import "PreTicktTwoCell.h"
#import "MJRefresh.h"


@interface MyCouponViewController ()<CustomActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    CustomActionSheet   * _sheet;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int      pageFlag;//请求页数
    int      buttonFlag;//请求button（未使用0，已使用1）
    int      totalFlag;//总页数
}
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *usedArr;
@property (nonatomic,strong) NSMutableArray *tenTArr;
@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    _tenTArr = [NSMutableArray arrayWithCapacity:1];
    _usedArr = [NSMutableArray arrayWithCapacity:1];
    // 3.集成刷新控件
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    titleButton.hidden = NO;
    [titleButton setTitle:@"我的优惠劵" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightNavItem setImage:[UIImage imageNamed:@"public_title_btn_edit.png"] forState:UIControlStateNormal];
    
    NSArray *name = @[@"未使用",@"已使用"];
//    [self showStartHud];
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
//    [self DownddateMode];
    [self.view addSubview:[self createControlWithItems:name]];
    /** 商户显示按钮frame设置 */
    _control.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
}

-(void)layoutSubviews{
    
}

- (void)addFooter
{
    __unsafe_unretained MyCouponViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _preferTabView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        pageFlag++;
        if (pageFlag <= totalFlag) {
        
            [self DownddateMode];
            [vc performSelector:@selector(doneWithViewTo:) withObject:refreshView afterDelay:0.3];
//            NSLog(@"---------1111111111----------");
        }else{
            [self showMsg:@"没有更多数据"];
            [self doneWithViewTo:_footer];
//            NSLog(@"---------2222222222----------");
        }
        
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained MyCouponViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _preferTabView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        pageFlag = 1;
        // 进入刷新状态就会回调这个Block
        [self DownddateMode];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithViewTo:) withObject:refreshView afterDelay:0.1];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

- (void)doneWithViewTo:(MJRefreshBaseView *)refreshView
{
    //    // 刷新表格
    //    [self.listTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
    NSLog(@"---------333333333----------");
}

- (void)DownddateMode{
    NSString *buttonFlagStr = [NSString stringWithFormat:@"%d",buttonFlag];
    NSString *pageFlagStr = [NSString stringWithFormat:@"%d",pageFlag];
    NSDictionary *parameter = @{@"oId":LYUserId,@"state":buttonFlagStr,@"page":pageFlagStr,@"rows":@"10",@"proIden":PROIDEN,@"phone":PhoneNumber};
    NSDictionary *dic = @{@"method":GETUSERCOUPONLIST,@"json":[parameter JSONRepresentation]};
    __block MyCouponViewController *myVC = self;
    [DownLoadData globalTimelinePostsWithBlock:^(NSArray *posts, NSString *str, NSError *error) {
        ZNLog(@"posts=%@",posts);
        totalFlag = [str intValue];
        [_dataArr removeAllObjects];
        if (posts.count > 0) {
            if (buttonFlag == 0) {
                if (pageFlag == 1) {
                    [_tenTArr removeAllObjects];
                }
                [_tenTArr addObjectsFromArray:posts];
                _dataArr = [NSMutableArray arrayWithArray:_tenTArr];
            }else if (buttonFlag == 1){
                if (pageFlag == 1) {
                    [_usedArr removeAllObjects];
                }
                [_usedArr addObjectsFromArray:posts];
                _dataArr = [NSMutableArray arrayWithArray:_usedArr];
            }
//            NSLog(@"%@",posts);
            
        }else{
            [myVC showMsg:@"没有优惠券哦"];
        }
        [_preferTabView reloadData];
        [_footer endRefreshing];
        [_header endRefreshing];
    } andWithdic:dic];
    NSLog(@"============%@",dic);
//    [self showStartHud]
}

- (void)creatTableView{
    _preferTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114) style:UITableViewStylePlain];
    _preferTabView.delegate = self;
    _preferTabView.dataSource = self;
    _preferTabView.backgroundColor = [UIColor lightGrayColor];
    [_preferTabView registerClass:[PreTicktTwoCell class] forCellReuseIdentifier:@"PreTicktTwoCell"];
    _preferTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
   _preferTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_preferTabView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier =@"PreTicktTwoCell";
    PreTicktTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             identifier];
    if (cell == nil) {
        cell = [[PreTicktTwoCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CouponModel *model = _dataArr[indexPath.row];
    [cell reshCelltoMode:model andWithIndex:indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PreferenTicktcoController * couponVC = [[PreferenTicktcoController alloc]init];
    CouponModel *model = _dataArr[indexPath.row];
    couponVC.couponId = model.couponId;
    couponVC.proIden = PROIDEN;
    NSString *valideTime = [NSString stringWithFormat:@"有效日期:%@至%@",model.validBeginTime,model.validEndTime];
     couponVC.valideTime = valideTime;
    couponVC.shopName = model.merchantName;
    if ([_dataArr isEqualToArray:_tenTArr]) {
    couponVC.usedTre = @"优惠券状态: 未使用";
    }else if([_dataArr isEqualToArray:_usedArr]){
    couponVC.usedTre = @"优惠券状态: 已使用";
    }
    //2015.8.15 yll
    if ([model.state isEqualToString:@"1"]) {
        couponVC.usedTre = @"优惠券状态: 已过期";
        couponVC.flagToStatus = 1;
    }
    couponVC.couponName = model.couponName;
    couponVC.oId = _oId;
    couponVC.ownerId = model.merchantId;
    couponVC.status = [NSString stringWithFormat:@"%ld",(long)model.state];
    [self.navigationController pushViewController:couponVC animated:YES];
    
}

-(void)backButtonClick{
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 右导航点击事件
-(void)sendBtn:(id)sender{
    if (_sheet == nil)
    {
        _sheet = [[CustomActionSheet alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
         [_sheet.clearBtn setTitle:@"清除过期的优惠劵" forState:UIControlStateNormal];
        _sheet.delegate           = self;
        
        [self.view addSubview:_sheet];
    }
    
}
- (DZNSegmentedControl *)createControlWithItems:(NSArray*)items
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:items];
        _control.selectedSegmentIndex = 0;
        _control.bouncySelectionIndicator = YES;
        _control.tintColor = RGBCOLOR(239, 60, 80);
        _control.animationDuration = 0.5;
        _control.backgroundColor = RGBCOLOR(250, 250, 250);
        _control.font = [UIFont fontWithName:@"EuphemiaUCAS" size:14.0];
        [_control setShowsGroupingSeparators:NO];
        _control.adjustsFontSizeToFitWidth = NO;
        _control.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
        [_control setShowsCount:NO];
        [_control addTarget:self action:@selector(selectedsSegment:) forControlEvents:UIControlEventTouchUpInside];
        
        _control.hairlineColor = [UIColor lightGrayColor];
        self.control.userInteractionEnabled = YES;
        [_control setTitleColor:RGBCOLOR(103, 103, 103) forState:UIControlStateNormal];
  
    }
    return _control;
}
- (void)selectedsSegment:(DZNSegmentedControl *)control{
//    if (self.locationlabelClickBlock) {
//        self.locationlabelClickBlock(self.control.tag);
//        NSLog(@"222");
//    }
    pageFlag = 1;
    if ([control selectedSegmentIndex] == 0) {
//    NSLog(@"222");
        buttonFlag =
   //     [self showStartHud1];
//        [self removeTableView];
//        [_dataArr removeAllObjects];
//        _dataArr = [NSMutableArray arrayWithArray:_tenTArr];
//        [self creatTableView];
//         [self creatLabel];
     //   [_preferTabView reloadData];
        buttonFlag = 0;
        
        
    }else{
        buttonFlag = 1;
        //   [self showStartHud1];
//        [self removeTableView];
//        [_dataArr removeAllObjects];
//        _dataArr = [NSMutableArray arrayWithArray:_usedArr];
//        [self creatTableView];
//        [self creatLabel];
    //    [_preferTabView reloadData];
       
//        NSLog(@"33");
    }
    [self DownddateMode];
}
- (void)creatLabel{
    if (_dataArr.count == 0) {
        UILabel *labeRit = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2+15, 100, 30 )];
        labeRit.text = @"暂无数据";
        labeRit.backgroundColor = [UIColor lightGrayColor];
        [labeRit setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:labeRit];
    }

}
- (void)removeTableView
{
    if ( _preferTabView != nil)
    {
        [ _preferTabView removeFromSuperview];
         _preferTabView.delegate = nil;
         _preferTabView.dataSource = nil;
         _preferTabView = nil;
   }
}


- (void)customActionSheetButtonIndex:(NSInteger)index
{
    if (index == 101)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清理过期优惠券!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
        NSLog(@"000");
        
}
    if(index == 102)
    {
        NSLog(@"111");
        
    
    }
    _sheet = nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {//分享
        if (buttonIndex == 1) {
            NSLog(@"从这里处理跳转的任务");
            NSDictionary *parameter = @{@"oId":LYUserId,@"proIden":PROIDEN,@"phone":PhoneNumber};
            NSDictionary *dic = @{@"method":@"deleteCouponList",@"json":[parameter JSONRepresentation]};
            NSLog(@"parameter=%@",parameter);
            if (_dataArr.count ==0) {
                [self showMsg:@"没有过期的优惠券可以清理"];
            }else{
                [DownLoadData delegeitTimelinePostsWithBlock:^(NSDictionary *posts, NSError *error) {
                    NSLog(@"posts=%@",posts);
                    NSString *sktStr = posts[@"rescode"];
                    if ( [sktStr isEqualToString: @"0000"]) {
                        [self showMsg:@"清除过期优惠券成功"];
//                        [self showStartHud];
                        [self DownddateMode];
                    }else{
                        [self showMsg:posts[@"resdesc"]];
                    }
                } andWithdic:dic];}
        }
    }
    
}




@end
