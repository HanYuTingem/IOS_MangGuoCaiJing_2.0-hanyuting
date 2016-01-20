//
//  GDHCouponBase_ViewController.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHCouponBase_ViewController.h"
#import "GDHInvalidCouponViewController.h"
#import "notCouponView.h"
#import "GDHCouponInfoViewController.h"
#import "LaoYiLaoViewController.h"
#import "WalletCouponInstructionViewController.h"
#define my_String(a)     [NSString stringWithFormat:@"%d",a]

@interface GDHCouponBase_ViewController ()<UITableViewDataSource,UITableViewDelegate,notCouponViewDelegate,GDHCouponTableViewCellDelegate>
{
    UILabel *gdhlable;
    /** 当前页 */
    int currentPage;
    /** 一页多少条 */
    int  pageSize;
    /**  一共多少页 */
    int totalPage;
    //上提加载
    MJRefreshFooterView        *_footer;
    //上提加载
    MJRefreshHeaderView        *_header;
}
/** 标题 按钮 */
@property(nonatomic,strong)UIButton *myCouponButtonButton;

@property(nonatomic,strong)MyCouponHeadView *couponHeadView;

/** 没有优惠券 */
@property(nonatomic,strong)notCouponView *notCoupon;
/** 筛选 */
@property(nonatomic,strong) GDHSelectCategoryView *selectCategoryView;
/**  我的优惠券类型 */
@property (nonatomic,copy) NSString *couponType;

/**  未使用优惠券 */
@property(nonatomic,strong)NSMutableArray *notUseCouponArray;
/** 已使用优惠券 */
@property(nonatomic,strong) NSMutableArray *usedCouponArray;

@end

@implementation GDHCouponBase_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mallTitleLabel removeFromSuperview];

    [backView addSubview:self.myCouponButtonButton];
    [self.view addSubview:self.couponTableView];
    [self.view addSubview:self.couponHeadView];
    self.view.backgroundColor = walletCouponBackgroundColor;
    [self.view addSubview:self.notCoupon];
    [self.view addSubview:self.selectCategoryView];
    
    currentPage = 1;
    pageSize = 10;

    [self.rightButton setTitle:@"说明" forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.couponState == couponUserStateExpired) {
        [self.notCoupon.invailView removeFromSuperview];
    }


}
- (void)rightBackCliked
{
    WalletCouponInstructionViewController *instruchtion = [[WalletCouponInstructionViewController alloc] init];
    [self.navigationController pushViewController:instruchtion animated:YES];
    NSLog(@"说明--");
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self chrysanthemumClosed];
}

- (NSMutableArray *)notUseCouponArray{
    if (_notUseCouponArray == nil) {
        _notUseCouponArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _notUseCouponArray;
}

-(NSMutableArray *)usedCouponArray{
    if (_usedCouponArray == nil) {
        _usedCouponArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _usedCouponArray;
}

#pragma  mark - 请求
-(void)mycouponRequest{
    [self chrysanthemumOpen];
    NSLog(@"   类型 ---  %d",self.couponState);
    
    NSLog(@"WalletHttp_Coupon_list--------%@",WalletHttp_Coupon_list);
    NSLog(@"self.couponType -----%@",self.couponType);
    
    NSDictionary *dict = [WalletRequsetHttp WalletCouponListUseState:my_String(self.couponState) andcurrentPage:my_String(currentPage) andpageSize:my_String(pageSize) andcouponType:self.couponType];
    
    [SINOAFNetWorking postCouponWithBaseURL:WalletHttp_Coupon_list controller:self params:dict success:^(id json) {
        if (json) {
            [self chrysanthemumClosed];
            NSDictionary *dict = json;
            NSLog(@"%@",dict);
            
            if (currentPage == 1) {
                [self.data removeAllObjects];
            }
            if ([dict[@"code"] isEqualToString:@"0000"]) {
                totalPage = [dict[@"totalPage"] intValue];
                NSArray *dictArray = dict[@"couponList"];
                if (dictArray.count <= 0) {
                    self.notCoupon.hidden = NO;
                }else{
                    self.notCoupon.hidden = YES;
                }

                for (NSDictionary *dic in dictArray) {
                    GDHCouponModel *model = [[GDHCouponModel alloc] initWithDict:dic];
                    [self.data addObject:model];
                }
                [self.couponTableView reloadData];
            }else{
                [self.data removeAllObjects];
                [self showMsg:dict[@"desc"]];
            }
        }
        [self endRefresh];

    } failure:^(NSError *error) {
        [self chrysanthemumClosed];
        [self endRefresh];
        
        NSLog(@"%@ +++++++  ",error);
    } noNet:^{
        [self chrysanthemumClosed];
        [self endRefresh];

        NSLog(@"111");
        
    }];
}

#pragma  mark - 标签视图（未使用，已使用）
-(void)MyCouponHeadViewNotUseButtonDown:(UIButton *)notUseButtonDown{
    NSLog(@"未使用");
    currentPage = 1;
    self.couponState = couponUserStateNOtUser;
    
    [self mycouponRequest];
    
}

- (void)MyCouponHeadViewAlreadyUsedButtonDown:(UIButton *)alreadyUsedButton{
    NSLog(@"已使用");
        currentPage = 1;
    self.couponState = couponUserStateUsed;
    
    [self mycouponRequest];
    
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
}
-(UIButton *)myCouponButtonButton{
    if (_myCouponButtonButton == nil) {
        _myCouponButtonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myCouponButtonButton setImage:[UIImage imageNamed:@"Wallet_youhuijuan_xialajiaobiao"] forState:UIControlStateNormal];
        [_myCouponButtonButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_myCouponButtonButton setTitle:@"我的优惠券" forState:UIControlStateNormal];
        _myCouponButtonButton.imageEdgeInsets = UIEdgeInsetsMake(8, [GCUtil widthOfString:@"我的优惠券" withFont:18] + 20, 0, 0);
        [_myCouponButtonButton addTarget:self action:@selector(mySelectCouponButtonButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myCouponButtonButton;
}

-(GDHSelectCategoryView *)selectCategoryView
{
    if (_selectCategoryView == nil) {
        _selectCategoryView = [[GDHSelectCategoryView alloc] init];
        _selectCategoryView.delegate = self;
        _selectCategoryView.layer.masksToBounds = YES;
        _selectCategoryView.hidden = YES;
        _selectCategoryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _selectCategoryView.frame = CGRectMake(0, 65, kkViewWidth, kkViewHeight - 65);
        
    }
    return _selectCategoryView;
}
-(MyCouponHeadView *)couponHeadView{
    if (_couponHeadView == nil) {
        _couponHeadView = [MyCouponHeadView myCouponHeadView];
        _couponHeadView.delegate = self;
    }
    return _couponHeadView;
}
-(GDHCouponFootView *)couponFootView{
    if (_couponFootView == nil) {
        _couponFootView = [GDHCouponFootView couponFootView];
        _couponFootView.frame = CGRectMake(0, 0, kkViewWidth, 46);
        _couponFootView.delegate = self;
//        _couponFootView.footerText = @"已过期优惠券";
    }
    return _couponFootView;
}
- (notCouponView *)notCoupon{
    if (_notCoupon == nil) {
        _notCoupon = [notCouponView notCoupon];
        _notCoupon.hidden = YES;
        
        _notCoupon.delegate = self;
    }
    return _notCoupon;
}
-(UITableView *)couponTableView{
    if (_couponTableView == nil) {
        _couponTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _couponTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _couponTableView.delegate = self;
        _couponTableView.dataSource = self;

        _couponTableView.backgroundColor = walletCouponBackgroundColor;
        [self addHeadRefresh];
        [self addFootRefresh];
    }
    return _couponTableView;
}
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.myCouponButtonButton.frame = CGRectMake( (kkViewWidth - [GCUtil widthOfString:@"我的优惠券" withFont:18]  - 20 )/2, 35, [GCUtil widthOfString:@"我的优惠券" withFont:18] + 30 , 20);
    _couponTableView.tableFooterView = self.couponFootView;

    if (self.heaViewIFShow) {
        self.couponHeadView.frame = CGRectMake(0, 64.5, kkViewWidth, 28);
            _couponTableView.frame = CGRectMake(0, 93, kkViewWidth, kkViewHeight - 93);
        _couponFootView.footerText = @"已过期优惠券";


    }else{
        _couponTableView.frame = CGRectMake(0, 64.5, kkViewWidth, kkViewHeight - 64.5) ;
        [self.couponHeadView removeFromSuperview];
//        _couponFootView.footerText = @"过期优惠券只为主公保存1个月哦~";
//        _couponFootView.userInteractionEnabled = NO;
        _couponTableView.tableHeaderView = [self makeHeadView];

    }
    if (self.couponState == 2) {
        _notCoupon.frame = CGRectMake(0, 65, kkViewWidth, kkViewHeight - 65);

    }else{
        _notCoupon.frame = CGRectMake(0, 100, kkViewWidth, kkViewHeight - 100);

    }
}

/** 添加头标题 */
- (UILabel *)makeHeadView {
    UILabel *heafLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 40)];
    heafLabel.text = @"过期优惠券只为主公保存1个月哦~";
    heafLabel.font = [UIFont systemFontOfSize:12];
    heafLabel.textColor = [UIColor blackColor];
    heafLabel.textAlignment = NSTextAlignmentCenter;
    return heafLabel;
}


#pragma  mark -  tableView 代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     GDHCouponTableViewCell *cell = [GDHCouponTableViewCell initWithTableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.couponModel = self.data[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GDHCouponModel *model = self.data[indexPath.row];
    if ([model.USE_STATE isEqualToString:@"2"] || [model.USE_STATE isEqualToString:@"1"]) {
        NSLog(@"已过期 不可以点击");
        return;
    }else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];

    }
    GDHCouponInfoViewController *vc  = [[GDHCouponInfoViewController alloc] init];
    vc.Model = model;

    [self.navigationController pushViewController:vc animated:YES];
}

-(void)GDHCouponFootViewBeOverdueButton:(UIButton *)beOverdueButton{
    
}
-(void)myCouponButtonButtonDown:(UIButton *)myCouponButtonButton{
    NSLog(@"基类标题按钮");
}

-(void)GDHCouponTableViewCellShareButton:(UIButton *)shareButton{
    NSLog(@"分享按钮  %ld",(long)shareButton.tag);
    
    GDHCouponModel *model = self.data[shareButton.tag - 2000];
    
    [self shareTitle:@"" withUrl: walletCouponShareURL  withContent:[NSString stringWithFormat:@"我在%@的活动中抢了张%@，你也快来抢吧!",walletCouponInfoProductName,model.COUPON_NAME] withImageName:@"" withShareType:1 ImgStr:model.LOGO_IMAGE domainName:@"用优惠券来践踏我的尊严"];

}


#pragma  mark - 没有优惠券
-(void)notCouponViewGetCoupon:(UIButton *)getCoupon{
    
    for (UIViewController *subVc in self.navigationController.viewControllers) {
        if([subVc isKindOfClass:[LaoYiLaoViewController class]]){
            [self.navigationController popToViewController:subVc animated:YES];
            return;
        }
    }
    LaoYiLaoViewController *Vc = [[LaoYiLaoViewController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
    NSLog(@"去获取优惠券");
}
-(void)notCouponviewInvailButton:(UIButton *)invailButton{
    GDHInvalidCouponViewController *vc = [[GDHInvalidCouponViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 标题按钮 （我的优惠券按钮）
-(void)mySelectCouponButtonButtonDown:(UIButton *)myCouponButtonButton{
    NSLog(@"标题按钮");
    [self.notCoupon bringSubviewToFront:self.selectCategoryView];
    [UIView animateWithDuration:0.5 animations:^{
        self.selectCategoryView.selectTableView.frame = CGRectMake(0, 0, kkViewWidth, 250);
        self.selectCategoryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.selectCategoryView.hidden = NO;
    }];
}

#pragma  mark - 选择的优惠券

/**  选择的 类型  */
-(void)GDHSelectCategoryViewSelectCategory:(NSString *)catrgory{
    NSLog(@"%@",catrgory);
    
    self.notCoupon.hidden = YES;
    if ([catrgory isEqualToString:@"全部"]) {
        self.couponType = @"";
    }else if ([catrgory isEqualToString:@"商城券"]){
        self.couponType = couponTypePlatform;
    }else if ([catrgory isEqualToString:@"代金券"]){
        self.couponType = couponTypeVoucher;
    }else if([catrgory isEqualToString:@"优惠券"]){
        self.couponType = couponTypeThird;
    }else if ([catrgory isEqualToString:@"实物券"]){
        self.couponType = couponTypeGoods;
    }
    
    NSLog(@"couponType++++++++++%@",self.couponType);
    [self mycouponRequest];
    [self GDHSelectCategoryViewHidden];
}
-(void)GDHSelectCategoryViewMaskButtonDown:(UIButton *)maskButton{
    [self GDHSelectCategoryViewHidden];
}

/** 遮罩消失 */
-(void)GDHSelectCategoryViewHidden{
    [UIView animateWithDuration:1 animations:^{
        self.selectCategoryView.selectTableView.frame = CGRectMake(0, -250, kkViewWidth, 250);
        self.selectCategoryView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.selectCategoryView.hidden = YES;
    }];
}

/**  下拉 */
-(void)addHeadRefresh{
    MJRefreshHeaderView  * header = [MJRefreshHeaderView header];
    header.scrollView = self.couponTableView;
    header.beginRefreshingBlock = ^ (MJRefreshBaseView * refreshView){
        //  后台执行：
        currentPage = 1;
        [self mycouponRequest];
    };
    _header = header;
}
/** 上拉 */
- (void)addFootRefresh{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.couponTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //  后台执行：
        currentPage++;
        if (totalPage >= currentPage) {
            [self mycouponRequest];
        } else {
            [self endRefresh];
            [self showMsg:showMessageNOData];
        }
    };
    _footer = footer;
}

-(void)endRefresh{
    [_footer endRefreshing];
    [_header endRefreshing];
}

@end
