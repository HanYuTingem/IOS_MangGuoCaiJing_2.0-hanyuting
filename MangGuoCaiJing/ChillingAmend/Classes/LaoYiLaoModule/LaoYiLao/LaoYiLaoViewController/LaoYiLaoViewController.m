//
//  LaoYiLaoViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/10/29.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LaoYiLaoViewController.h"
#import "BarView.h"
#import "LoadEffectView.h"
#import "SSNoNetView.h"
#import "BaoJiaoziView.h"
#import "SSMyDumplingModel.h"
#import "GetShareInfoModel.h"
#import "ActivityRuleViewController.h"
#import "LYLQuickLoginViewController.h"
#import "mineWalletViewController.h"
#import "AnimateView.h"
#import "BouncedView.h"
#import "ScrollBox.h"
#import "ScrollBoxItemView.h"
#import "ClickOnTheMoreView.h"
#import "SchematicDiagramView.h"
#import "GetMaxNumberModel.h"
#import "DumplingInforModel.h"
#import "DumplingInforListModel.h"
#import "NoGetMoneyView.h"
#import "UMSocial.h"
#import "RemainingDumplingNumberModel.h"
#import "WebViewController.h"
#import "ShareInfoManage.h"
#import "MyDumplingViewController.h"
#import "ZHMakeDumplingView.h"
#import "NoServerView.h"
#import "ZHAdvertisingView.h"
#import "VoteView.h"
#import "LYLAdvertisingModel.h"

#define MidHeight 2
#define AnimateHeight 450 *KPercenY//捞饺子动画的高度
#define LaoYiLaoScrollViewContentSize_H 0//捞一捞scrollView的contentsize高度
#define TimeIsOneDumplingList 18 / TimeMid / 2

//时间轴定时请求
#define TimeListForTimeMid (60 *1)
////ScrollBox的frame
//#define ScrollBoxX 0
//#define ScrollBoxY CGRectGetMaxY(_animateView.frame)-2
//#define ScrollBoxW kkViewWidth
//#define ScrollBoxH 204

//advertisingView 的frame
#define AdvertisingViewX 0
#define AdvertisingViewY CGRectGetMaxY(_animateView.frame)-2
#define AdvertisingViewW kkViewWidth
#define AdvertisingViewH 706 / 2 * KPercenY

//点击更多的frame
#define ClickOnTheMoreViewX 0
#define ClickOnTheMoreViewY CGRectGetMaxY(_advertisingView.frame ) + LaoYiLaoScrollViewContentSize_H
#define ClickOnTheMoreViewW
#define ClickOnTheMoreViewH 48 *KPercenY


//VoteView的frame
#define VoteViewX 0
#define VoteViewY 110 *KPercenY
#define VoteViewW 150 / 2 *KPercenX
#define VoteViewH 150 / 2 *KPercenX


////未领取钱的Frame
//#define NoGetMoneyViewX 0//无所谓居中
//#define NoGetMoneyViewY 5 * KPercenY
//#define NoGetMoneyViewW 300
//#define NoGetMoneyViewH 30


@interface LaoYiLaoViewController ()<LoadEffectViewDelegate,UIScrollViewDelegate,AnimateViewDelegate,GetMoneyViewDelegate>
{

    //开场动画的加载view
    LoadEffectView * _loadEffectView;
    //最底层view
    UIView *_backgroudView;
    //选择器的backView
    UIView *_titleView;
    //包饺子。捞一捞 界面的背景scrollview
    UIScrollView *_scrollView;
    //当前界面的索引
    int _currentIndex;
    //捞一捞界面的ScrollewView
    UIScrollView *_laoYiLaoScrollView;
    //包饺子界面的ScrollewView
    UIScrollView *_makeDumplingScrollView;
    //默认一点击勺就开始捞
    AnimateView *_animateView;
    //捞一捞没网界面
    SSNoNetView *_ssNoNetView;
    //捞一捞服务器出问题界面
    NoServerView *_noServiewView;
    //弹框的view
    BouncedView *_bounceView;
    //中奖信息的滚动的box
//    ScrollBox *_scrollBox;
    //
    ZHAdvertisingView *_advertisingView;
    //第一次进的时候  示意图界面
    SchematicDiagramView *_schematicDiagramView;
//    //点击更多的view
//    ClickOnTheMoreView *_clickedOthTheMoreView;
    
    //未登录最大捞取次数
    int _maxNumber;
    //首页时间列表 0关1开
    BOOL _timeup;
    //投票0关1开
    BOOL _vote;
    NSString *_voteUrl;
 
    //中奖信息的数据
    NSMutableArray *_dumplingInforArray;
    //定时请求
//    NSTimer *_timer;
    //没有领取的view
    NoGetMoneyView *_noGetMoneyView;
    //包饺子view
    ZHMakeDumplingView *_makeDumplingView;
    //投票view
    VoteView *_voteView;
    
     NSTimer *_moveTimer;//捞饺子时间定时器

}

@end

@implementation LaoYiLaoViewController

#pragma mark --视图的生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
//    [_scrollBox startTimer];//开启定时器
//    [_timer setFireDate:[NSDate distantPast]];//开启定时器
    if(_moveTimer){
        [_moveTimer  setFireDate:[NSDate distantPast]];//开启定时器
    }
    [_animateView startTimer];
    
    //选中上一次选中的 **********************************
    if(_currentIndex == 2 || _currentIndex == 3){
        NSLog(@"%d",self.switchView.preIndex);
        [self.switchView rollingBackViewWithIndex:self.switchView.preIndex];
        _currentIndex = self.switchView.preIndex;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [_scrollBox stopTimer];//关闭定时器
//    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    [_moveTimer  setFireDate:[NSDate distantFuture]];//开启定时器
    [_animateView stopTimer];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkStateChange:) name:@"netStateChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchViewSelectIndex:) name:@"popLYLVC" object:nil];
    
    if(!_userID){
        _userID = @"";
    }
    if(!_phone){
        _phone = @"";
    }
    MySetObjectForKey(_userID, UserIDKey);//存userID
    MySetObjectForKey(_phone, LoginPhoneKey);//存手机号
    NSLog(@"LYLUserId = %@, LYLPhone = %@",LYLUserId,LYLPhone);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, NavgationBarHeight)]];
    //设置导航
    [self setNav];
    //开场动画
    [self createLoadView];
    // 初始化变量
    [self initVariable];
}
#pragma mark -- setNav
- (void)setNav{
    [self changeBarTitleWithString:@"捞一捞"];
    self.customNavigation.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, NavgationBarHeight)]];
    self.customNavigation.shareButton.hidden = NO;
    self.customNavigation.rightButton.hidden = NO;
}
#pragma mark --  初始化变量
- (void)initVariable{
    _currentIndex = 0;
    _dumplingInforArray = [NSMutableArray array];
    _bounceView = [BouncedView shareBounceView];
    _bounceView.viewController = self;
}

#pragma mark --  监听通知
- (void)switchViewSelectIndex:(NSNotification *)infor{
    /**
     *  [[NSString stringWithFormat:@"%@",infor.object] intValue] 
     *  -1 选中上一次选中的
     */
    NSLog(@"%d",self.switchView.preIndex);

    if([[NSString stringWithFormat:@"%@",infor.object] intValue] > -1){
        [self.switchView rollingBackViewWithIndex: [[NSString stringWithFormat:@"%@",infor.object] intValue]];
        _currentIndex = [[NSString stringWithFormat:@"%@",infor.object] intValue];
    }
//    if([[NSString stringWithFormat:@"%@",infor.object] intValue] == -1){//选中上一次选中的
////        [self.switchView rollingBackViewWithIndex:self.switchView.preIndex];
////        _currentIndex = self.switchView.preIndex;
//    }else{
//        [self.switchView rollingBackViewWithIndex: [[NSString stringWithFormat:@"%@",infor.object] intValue]];
//        _currentIndex = [[NSString stringWithFormat:@"%@",infor.object] intValue];
//    }
}

#pragma mark 开场加载动画
-(void)createLoadView{
    _loadEffectView = [[LoadEffectView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight)];
    _loadEffectView.delegate = self;
    [_loadEffectView initUI];
}
-(void)startupview{
    [UIView animateWithDuration:2 animations:^{
        _loadEffectView.alpha = 0;
    }];
    [self createTiteView];//创建ui
    [self performSelector:@selector(removeView) withObject:nil afterDelay:0.5];
}
-(void)removeView{
    _loadEffectView.alpha = 0;
    [_loadEffectView removeFromSuperview];
}


#pragma navigationBarDelegate
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)helpBtnClicked{
    ActivityRuleViewController * ar = [[ActivityRuleViewController alloc]init];
    [self.navigationController pushViewController:ar animated:YES];
}


#pragma mark --  监听网络状态的通知
- (void)netWorkStateChange:(NSNotification *)notInfor{
    NSString *str = (NSString *)notInfor.object;
    if([str isEqualToString:@"1"]){
        ZHLog(@"LaoYiLaoViewController = 有网");
        if(_advertisingView){
            [self networkStatusOKWithView];
        }
        if(_currentIndex == 0 || _currentIndex == 1){
            [self loadDataRemainingDumplingWithNumber];
        }
    }else if([str isEqualToString:@"0"]){
        ZHLog(@"LaoYiLaoViewController = 没网");
        if(_advertisingView){
            [self networkStatusNOWithView];
        }
    }
}
#pragma mark 我的饺子界面按钮的代理方法
//分享活动
-(void)shareBtnClicked:(UIButton *)btn{
    if (_currentIndex == 0) {
        
        
        //    socialControllerService.currentViewController =
//        MySetObjectForKey(ShareTypeWithNavBarLaoYiLao, ShareTypeKey);
        [ShareInfoManage shareWithType:ShareTypeWithScoopDumplingActivity andContentStr:@"" andViewController:self];
        ZHLog(@"活动分享");
    }else if (_currentIndex == 1){
//        MySetObjectForKey(ShareTypeWithNavBarMakeDumpling, ShareTypeKey);
        [ShareInfoManage shareWithType:ShareTypeWithMakeDumplingActivity andContentStr:@"" andViewController:self];
        ZHLog(@"包饺子分享");
    }else{
    
    }
}
#pragma mark -- 添加选择及title图片
- (void)createTiteView{
    //最底层的view
    _backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, kkViewHeight + PosterHeight)];
    _backgroudView.userInteractionEnabled = YES;
    [self.view addSubview:_backgroudView];
    //选择控件的backView
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, (PosterHeight+SwitchHeight + MidHeight * 2))];
    _titleView.backgroundColor = [UIColor clearColor];
    [_backgroudView addSubview:_titleView];
    //选择控件
    _switchView = [[ScrollTitleView alloc]initWithFrame:CGRectMake(SelectSwitchX,2,kkViewWidth - SelectSwitchX * 2,SwitchHeight)];
    [_switchView createItem:@[@"捞一捞",@"包饺子",@"我的饺子",@"我的钱包"]];
    _switchView.backgroundColor = [UIColor clearColor];
    _switchView.layer.borderWidth = 1;
    _switchView.layer.borderColor = [UIColor whiteColor].CGColor;
    _switchView.layer.cornerRadius = 5;
    _switchView.clipsToBounds = YES;
    _switchView.layer.masksToBounds = YES;
    [_titleView addSubview:_switchView];
    //添加backScrollew
    [self addScrollewView];
}

#pragma mark -- 选择控件的点击事件
- (void)switchViewClicked{
    __weak  UIScrollView *blockScrollView = _scrollView;
    __weak LaoYiLaoViewController * vc = self;
    __weak ZHMakeDumplingView *selfMakeDumpingView = _makeDumplingView;
    [_switchView setSelectIndexWithBlock:^(int index) {
        _currentIndex = index;
        //包饺子按钮隐藏
        if(index != 1){//不是包饺子
            selfMakeDumpingView.greetingCardBtn.hidden = YES;
            selfMakeDumpingView.moneyBtn.hidden = YES;
            selfMakeDumpingView.selecetButton.selected = NO;
        }
        
        if(index == 0){//捞一捞
            [vc changeBarTitleWithString:@"捞一捞"];
//            vc.customNavigation.shareButton.hidden = NO;
            vc.customNavigation.rightButton.hidden = NO;
            blockScrollView.contentOffset = CGPointMake(kkViewWidth *index, 0);
        }else if (index == 1){//包饺子
            [vc changeBarTitleWithString:@"包饺子"];
//            vc.customNavigation.shareButton.hidden = YES;
            vc.customNavigation.rightButton.hidden = YES;
            if(LYLIsLoging){//已登陆
                blockScrollView.contentOffset = CGPointMake(kkViewWidth *index, 0);
            }else{
                LYLQuickLoginViewController  * quickLoginVC = [[LYLQuickLoginViewController alloc]init];
                quickLoginVC.enterType = EnterTypeMakeDumpilng;
                quickLoginVC.backBlock = ^void(){
                    if(LYLIsLoging){//已登陆
                        blockScrollView.contentOffset = CGPointMake(kkViewWidth *index, 0);
                        
                    }else{
                        [vc.switchView rollingBackViewWithIndex:0];
                        _currentIndex = 0;
                    }
                };
                [vc.navigationController pushViewController:quickLoginVC animated:YES];
            }
        }else if (index == 2){//我得饺子
            if (LYLIsLoging) {//已登陆
                MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
                [vc.navigationController pushViewController:myDumplingVc animated:YES];
                
            }else{
                LYLQuickLoginViewController  * quickLoginVC = [[LYLQuickLoginViewController alloc]init];
                quickLoginVC.enterType = EnterTypeMyDumpling;
                quickLoginVC.backBlock = ^void(){
                    if(LYLIsLoging){//已登陆
                        MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
                        [vc.navigationController pushViewController:myDumplingVc animated:YES];
                    }else{
                        [vc.switchView rollingBackViewWithIndex:0 ];
                        _currentIndex = 0;
                    }
                };
                [vc.navigationController pushViewController:quickLoginVC animated:YES];
            }
            
        }else if (index == 3){//我得钱包
            if (LYLIsLoging) {//已登陆
                BOOL isYesNO = NO;//YES ----> pop NO----Push
                for (UIViewController *subVC in vc.navigationController.viewControllers) {
                    if([subVC isKindOfClass:[mineWalletViewController class]]){
                        isYesNO = YES;
                        [vc.navigationController popToViewController:subVC animated:YES];
                    }
                }
                if(isYesNO == NO){
                    mineWalletViewController *walletViewVC = [[mineWalletViewController alloc]init];
                    [vc.navigationController pushViewController:walletViewVC animated:YES];
                }
            }else{
                LYLQuickLoginViewController  * quickLoginVC = [[LYLQuickLoginViewController alloc]init];
                quickLoginVC.enterType = EnterTypeMyWallect;
                quickLoginVC.backBlock = ^void(){
                    [vc.switchView rollingBackViewWithIndex:0 ];
                    _currentIndex = 0;
                };
                [vc.navigationController pushViewController:quickLoginVC animated:YES];
            }
        }
    }];
}

#pragma mark -- 添加背景scrollview
- (void)addScrollewView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), kkViewWidth, kkViewHeight - (NavgationBarHeight + SwitchHeight + 2 * MidHeight))];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kkViewWidth * 2, 1);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.userInteractionEnabled = YES;
    [_backgroudView addSubview:_scrollView];
    //添加捞一捞界面
    [self addLaoYiLaoView];
    //添加包饺子界面
    [self addBaoJiaoZiView];
    //选择器的点击事件
    [self switchViewClicked];

//    [self.view bringSubviewToFront:self.customNavigation];
}

#pragma mark -- 添加捞一捞界面
- (void)addLaoYiLaoView{
    //创建捞一捞的滚动视图
    _laoYiLaoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - NavgationBarHeight - SwitchHeight - MidHeight * 2)];
    _laoYiLaoScrollView.scrollEnabled = YES;
    _laoYiLaoScrollView.bounces = NO;
    _laoYiLaoScrollView.userInteractionEnabled = YES;
    _laoYiLaoScrollView.showsVerticalScrollIndicator = NO;
    _laoYiLaoScrollView.backgroundColor = [UIColor clearColor];
    _laoYiLaoScrollView.delegate = self;
    [_scrollView addSubview:_laoYiLaoScrollView];
    //添加捞一捞没网界面
    [self addLaoYiLaoNONetworkView];
    //添加捞一捞有网界面
    [self addLaoYiLaoYESNetworkView];
    //添加捞一捞服务器出问题界面
    [self addServerNoConnection];
    //添加网络
    if([LYLTools netWorkIsOk]){
        [self networkStatusOKWithView];
        [self loadDataRemainingDumplingWithNumber];

    }else{
        [self networkStatusNOWithView];
    }
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeIsOneDumplingList target:self selector:@selector(loadDataUserDumplingList) userInfo:nil repeats:YES];//循环掉中奖信息
}

#pragma mark -- 添加捞一捞没网的界面
- (void)addLaoYiLaoNONetworkView{
    ZHLog(@"增加没网界面");
    //没网的界面
    _ssNoNetView = [[SSNoNetView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - NavgationBarHeight - SwitchHeight - MidHeight * 2)];
    _ssNoNetView.hidden = YES;
    [_laoYiLaoScrollView addSubview:_ssNoNetView];
}
#pragma mark --添加服务器出问题界面
- (void)addServerNoConnection{
    _noServiewView = [[NoServerView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewHeight - NavgationBarHeight - SwitchHeight - MidHeight * 2)];
    _noServiewView.hidden = YES;
    [_laoYiLaoScrollView addSubview:_noServiewView];
}
#pragma mark -- 添加捞一捞有网界面
- (void)addLaoYiLaoYESNetworkView{
    ZHLog(@"增加有网界面");

    //添加捞饺子动画view
    _animateView = [[AnimateView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, AnimateHeight)];
    _animateView.delegate  = self;
    _animateView.userInteractionEnabled = YES;
//    _animateView.backgroundColor = [UIColor grayColor];
    [_laoYiLaoScrollView addSubview:_animateView];
    
    //添加中奖框view
//    _scrollBox = [[ScrollBox alloc]initWithFrame:CGRectMake(ScrollBoxX, ScrollBoxY, ScrollBoxW, ScrollBoxH)];
////    _scrollBox.backgroundColor = [UIColor blackColor];
//    [_laoYiLaoScrollView addSubview:_scrollBox];
    
    _advertisingView = [[ZHAdvertisingView alloc]initWithFrame:CGRectMake(AdvertisingViewX, AdvertisingViewY, AdvertisingViewW, AdvertisingViewH)];
    [_laoYiLaoScrollView addSubview:_advertisingView];
    //添加点击更多view
//    __block UIViewController *weakVC = self;
//    _clickedOthTheMoreView = [[ClickOnTheMoreView alloc]initWithFrame:CGRectMake(ClickOnTheMoreViewX, ClickOnTheMoreViewY, kkViewWidth, ClickOnTheMoreViewH)];
//    _clickedOthTheMoreView.moreBtnBlock = ^void(UIButton *button){
//        WebViewController *webView = [[WebViewController alloc]init];
//        [weakVC.navigationController pushViewController:webView animated:YES];
//    };
//    [_laoYiLaoScrollView addSubview:_clickedOthTheMoreView];
    //判断是不是第一次进入这个界面
    if(!MyObjectForKey(IsFirstKey)){
        __block LaoYiLaoViewController *blockLYLVC = self;
        _schematicDiagramView = [[SchematicDiagramView alloc]init];
        _schematicDiagramView.FirstBtnClickedBlock = ^void(){
            
            [blockLYLVC laoYiLaoAnimateBegin];//开始捞
            //            [blcokAnimateView start];//开始捞
            MySetObjectForKey(IsFirstNO,IsFirstKey);// 设置不是第一次启动
            ZHLog(@"将是否为第一次进入当前界面设置为否");
        };
        [[UIApplication sharedApplication].keyWindow addSubview:_schematicDiagramView];
    }
    //添加有饺子没有领取的view
    _noGetMoneyView = [NoGetMoneyView shareGetMoneyView];
    _noGetMoneyView.center = CGPointMake(kkViewWidth / 2, _noGetMoneyView.center.y);
    [_noGetMoneyView refreshShareGetMoneyView];
    _noGetMoneyView.delegate = self;
    [_animateView addSubview:_noGetMoneyView];
    
     _voteView = [[VoteView alloc]initWithFrame:CGRectMake(VoteViewX, VoteViewY, VoteViewW, VoteViewH)];
    [_voteView.voteBtn addTarget:self action:@selector(voteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_laoYiLaoScrollView addSubview:_voteView];
    
}

#pragma mark -- 投票链接
- (void)voteBtnClicked:(UIButton *)button{
    NSLog(@"点击了投票");
    if(LYLIsLoging){
        WebViewController *webVc = [[WebViewController alloc]init];
        webVc.url = _voteUrl;
        [self.navigationController pushViewController:webVc animated:YES];
    }else{
        LYLQuickLoginViewController *quickVc = [[LYLQuickLoginViewController alloc]init];
        quickVc.enterType = EnterTypeMainWithVote;
        quickVc.backBlock = ^void(){};
        [self.navigationController pushViewController:quickVc animated:YES];
        ZHLog(@"去领钱");
    }
}
#pragma mark -- getMoneyDelegate
- (void)getMoney{
    if(LYLIsLoging){//已登陆
        [self loadDataWithNoLoginGetMoney];
    }else{
        LYLQuickLoginViewController *quickVc = [[LYLQuickLoginViewController alloc]init];
        quickVc.enterType = EnterTypeMainWithGetMoney;
        quickVc.backBlock = ^void(){};
        [self.navigationController pushViewController:quickVc animated:YES];
        ZHLog(@"去领钱");
    }
}

#pragma mark -- 添加包饺子界面
- (void)addBaoJiaoZiView{
    
    _makeDumplingScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kkViewWidth, 0, kkViewWidth, kkViewHeight - NavgationBarHeight - SwitchHeight)];
    _makeDumplingScrollView.backgroundColor = [UIColor clearColor];
    _makeDumplingScrollView.delegate = self;
    _makeDumplingScrollView.bounces = NO;
    _makeDumplingScrollView.userInteractionEnabled = YES;
    _makeDumplingScrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:_makeDumplingScrollView];
    
    _makeDumplingView = [[ZHMakeDumplingView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, _makeDumplingScrollView.frame.size.height)];
    _makeDumplingView.viewController = self;
    _makeDumplingView.userInteractionEnabled = YES;
    [_makeDumplingScrollView addSubview:_makeDumplingView];
    
//    _makeDumplingScrollView.contentSize =  CGSizeMake(1, CGRectGetMaxY(_makeDumplingView.frame));
}
#pragma mark -- 有网view的显示状态
- (void)networkStatusOKWithView{
    ZHLog(@"显示有网界面");
    _animateView.hidden = NO;
//    _scrollBox.hidden = NO;
    _advertisingView.hidden = NO;
//    _clickedOthTheMoreView.hidden = NO;
    _noServiewView.hidden = YES;
    _ssNoNetView.hidden = YES;
    _voteView.hidden = YES;
    _laoYiLaoScrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(_advertisingView.frame) + LaoYiLaoScrollViewContentSize_H);
//    _laoYiLaoScrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(_clickedOthTheMoreView.frame) + LaoYiLaoScrollViewContentSize_H);
    
}
#pragma mark -- 没网view的显示状态
- (void)networkStatusNOWithView{
    ZHLog(@"显示无网界面");
    _animateView.hidden = YES;
    _advertisingView.hidden = YES;
    if(_vote){
        _voteView.hidden = NO;
    }else{
        _voteView.hidden = YES;
    }
//    _scrollBox.hidden = YES;
//    _clickedOthTheMoreView.hidden = YES;
    _noServiewView.hidden = YES;
    _ssNoNetView.hidden = NO;
    _laoYiLaoScrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(_ssNoNetView.frame) + LaoYiLaoScrollViewContentSize_H);
}
//#pragma mark -- 服务器出问题view显示的状态
//- (void)serverNoConnectionWithView{
//    _animateView.hidden = YES;
//    _scrollBox.hidden = YES;
//    _clickedOthTheMoreView.hidden = YES;
//    _noServiewView.hidden = NO;
//    _ssNoNetView.hidden = YES;
//    _laoYiLaoScrollView.contentSize = CGSizeMake(1, CGRectGetMaxY(_noServiewView.frame) + LaoYiLaoScrollViewContentSize_H);
//}

#pragma mark --  scrollView 的delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView == _scrollView){
//        _currentIndex = scrollView.contentOffset.x/kkViewWidth;
//    }
    if(_currentIndex == 0){
//        [_scrollBox startTimer];//开启定时器
        [_animateView startTimer];

    }else{
//        [_scrollBox stopTimer];//关闭定时器
        [_animateView stopTimer];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [_switchView rollingBackViewWithIndex:_currentIndex];
}


#pragma mark -- 动画的delegate
- (void)laoYiLaoAnimateBegin{
    ZHLog(@"%@",LYLUserId);
    if(LYLIsLoging){
        [self loadDataLogingDumping];//登录捞饺子
    }else{
        [self loadDataNOLogingDumpling];//没有登录
    }
}

- (void)laoYiLaoAnimateFinished{

    if(_currentIndex == 0){
        [_bounceView addDumplingInforView];
        [[NoGetMoneyView shareGetMoneyView]refreshShareGetMoneyView];//更改跑马灯的状态
    }
    NSLog(@"结束捞");
}




#pragma mark --- 获取未登录捞取饺子上限
/**
 *  获取未登录捞取饺子上限
 */
- (void)loadDataNoLoginStatusMaxNumber{
    
    [self showHudInView:self.view hint:@"正在加载"];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool noLogingNumberCeilingWithProductCode:ProductCode sysType:SysType andSessionValue:SessionValue] success:^(id json) {
        
        ZHLog(@"获取未登录捞取饺子上限json=%@",json);
        [self hideHud];
        if([json[@"code"] isEqualToString:@"100"]){
            
            GetMaxNumberModel *maxNumberModel = [GetMaxNumberModel getMaxNumberModelWithDic:(NSDictionary *)json];
            if([maxNumberModel.code isEqualToString:@"100"]){
                _maxNumber = IsStrWithNUll(maxNumberModel.count) ? 0 : [maxNumberModel.count intValue];
//                [self loadDataUserDumplingList];
                [self loadDataAdvertisingList];
            }
            
        }
    } failure:^(NSError *error) {
        ZHLog(@"获取未登录捞取饺子上限失败=%@",error);
//        [self serverNoConnectionWithView];
        [self hideHud];
    }];
}


#pragma mark -- 未登录状态下捞饺子
- (void)loadDataNOLogingDumpling{
    
    [self showHudInView:self.view hint:@""];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool noLogingUserDumplingWithProductCode:ProductCode sysType:SysType andSessionValue:SessionValue] success:^(id json) {
        
        [self hideHud];
//        _maxNumber = 1000000;
        ZHLog(@"未登录状态下捞饺子json = %@",json);
        if([((NSDictionary *)json)[@"code"] isEqualToString:@"100"]){
        
            
            DumplingInforModel *dumplingModel = [DumplingInforModel dumplingInforModelWithDic:(NSDictionary *)json];
//            dumplingModel.resultListModel.dumplingModel.dumplingType = @"8";
//            dumplingModel.resultListModel.dumplingModel.cardId = @"98";
//            dumplingModel.resultListModel.dumplingModel.cardType = @"1";
//            dumplingModel.resultListModel.dumplingModel.cardUrl = @"http://192.168.10.62:8086/fileUpload/Image/coupon/20160105/f457e508dca34b11a742f5c1e10d591b.jpg";
//            dumplingModel.resultListModel.dumplingModel.createDate = @"1452162762677";
//            dumplingModel.resultListModel.dumplingModel.dumplingType = @"4";
//           dumplingModel.resultListModel.dumplingModel. prizeAmount = @"";
////            dumplingModel.resultListModel.dumplingModel.productcode = @"XN01_SINOSNS_QYY";
//            dumplingModel.resultListModel.dumplingModel.putUser = @"U6309U5230";
////            dumplingModel.resultListModel.dumplingModel.sessionValue = 354bf5d28d66ac3c372470410128de2b;
//            dumplingModel.resultListModel.dumplingModel.status = @"1";
//            dumplingModel.resultListModel.dumplingModel.sysType = @"3";
//            dumplingModel.resultListModel.dumplingModel.userImg = @"http://192.168.10.11:2023/dumpling2/dumpling_img/2016/01/05/20160105153306_958.jpg";
            if([[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"0" andUserId:@""] < _maxNumber){
                
                /**
                 *  插入数据
                 */
                [[ZHDataBase sharedDataBase]insertWithModel:dumplingModel logingState:@"0" andUserId:LYLUserId];
                dumplingModel.resultListModel.userHasNum = [NSString stringWithFormat:@"%d",_maxNumber - [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"0" andUserId:@""]];//设置剩余次数
                ZHLog(@"有次数%d开始捞",_maxNumber - [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"0" andUserId:@""]);
                
                _bounceView.dumplingInforModel = dumplingModel;
                [_animateView start];//开始动画
                //记录当前时间 存起来
                MySetObjectForKey([LYLTools currentDateWithDay], DumplingTheLastTimeKey);
                
            }else{//没机会
                
                [_bounceView addSharedWithCeilingViewType:@"1"];
                ZHLog(@"没次数  次数%d",_maxNumber - [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"0" andUserId:@""]);
            }
        }else{
            [_bounceView addSharedWithCeilingViewType:@"2"];
//            [LYLTools showInfoAlert:@"服务器挤爆了，稍后再来哦"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [_bounceView addSharedWithCeilingViewType:@"3"];
//        [LYLTools showInfoAlert:@"网络太慢啦~"];
        ZHLog(@"%@",error);
    }];
}

#pragma mark -- 登陆用户捞饺子
/**
 *  登陆用户捞饺子
 */
- (void)loadDataLogingDumping{
    
    [self showHudInView:self.view hint:@""];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool logingUserDumplingWithUserId:MyObjectForKey(UserIDKey) logingPhone:LYLPhone  productCode:ProductCode sysType:SysType andSessionValue:SessionValue] success:^(id json) {
        ZHLog(@"登陆用户捞饺子json =%@",json);
        [self hideHud];
        
        if([((NSDictionary *)json)[@"code"] isEqualToString:@"102"]){//没有次数
            [_bounceView addSharedWithCeilingViewType:@"1"];
        }else if([((NSDictionary *)json)[@"code"] isEqualToString:@"100"]){//成功有次数
            DumplingInforModel *dumplingInforModel = [DumplingInforModel dumplingInforModelWithDic:(NSDictionary *)json];
//            dumplingInforModel.resultListModel.dumplingModel.cardType = @"2";
            [[ZHDataBase sharedDataBase]insertWithModel:dumplingInforModel logingState:@"1" andUserId:LYLUserId];
            
            _bounceView.dumplingInforModel = dumplingInforModel;
            [_animateView start];//开始动画
            
            /**
             *  记录当前捞饺子时间
             */
            MySetObjectForKey([LYLTools currentDateWithDay], DumplingTheLastTimeKey);
            
        }else{
            [_bounceView addSharedWithCeilingViewType:@"2"];
        //            [LYLTools showInfoAlert:@"服务器挤爆了，稍后再来哦"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [_bounceView addSharedWithCeilingViewType:@"3"];
//        [LYLTools showInfoAlert:@"网络太慢啦~"];
        ZHLog(@"登陆用户捞饺子= %@",error);
    }];
    
}

//#pragma mark -- 别人捞到饺子消息的列表
///**
// *  捞饺子用户列表(按时间倒序)
// */
//- (void)loadDataUserDumplingList{
//    
//    //清除失效的缓存饺子
//    [LYLTools removeDumplingInforOfFailure];
//    [[NoGetMoneyView shareGetMoneyView]refreshShareGetMoneyView];//更新跑马灯
//    
//    
//    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool userDumplingListWithProductCode:ProductCode sysType:SysType andSessionValue:SessionValue ] success:^(id json) {
//        ZHLog(@"捞饺子用户列表(按时间倒序)json = %@",json);
//        if([json[@"code"] isEqualToString:@"107"]){
//            [LYLTools showInfoAlert:@"还没有中奖信息哦"];
//        }else if ([json[@"code"] isEqualToString:@"100"]){
//            DumplingInforListModel *dumplingInforModel = [DumplingInforListModel dumplingInforListModelWithDic:(NSDictionary *)json];
//            [_dumplingInforArray addObjectsFromArray:dumplingInforModel.dumplingInforList];
//            if(_dumplingInforArray.count != 0){
//                [_scrollBox addItemWithArray:_dumplingInforArray];
//            }
//        }else{
//            [LYLTools showInfoAlert:@"服务器挤爆了，稍后再来哦"];
//        }
//    } failure:^(NSError *error) {
//        ZHLog(@"%@",error);
//        [self showHint:@"网络状态不好，中奖信息加载失败"];
//    }];
//}


#pragma mark -- 广告位list
- (void)loadDataAdvertisingList{
    //清除失效的缓存饺子
    [LYLTools removeDumplingInforOfFailure];
    [[NoGetMoneyView shareGetMoneyView]refreshShareGetMoneyView];//更新跑马灯
//    _animateView.titleImageView.hidden = NO;
    [self showHudInView:self.view hint:@"正在加载"];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool getAdvertisingListWithProductCode:ProductCode sysType:SysType sessionValue:SessionValue] success:^(id json) {
        ZHLog(@"广告位list == %@",json);
        [self hideHud];
        if([json[@"code"] isEqualToString:@"100"]){
            LYLAdvertisingModel *model = [LYLAdvertisingModel advertisingModelWithDic:(NSDictionary *)json];
            [_advertisingView.advertisingItemView createItems:model.resultModels];
        }
        if(_timeup){
            [self loadDataTimeList];
            _moveTimer = [NSTimer scheduledTimerWithTimeInterval:TimeListForTimeMid target:self selector:@selector(loadDataTimeList) userInfo:nil repeats:YES];

        }
    } failure:^(NSError *error) {
        [self hideHud];
        ZHLog(@"%@",error);
    }];
}

#pragma mark -- 时间表
- (void)loadDataTimeList{
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool getTimeAxisWithProductCode:ProductCode sysType:SysType sessionValue:SessionValue] success:^(id json) {
        
        ZHLog(@"时间表list == %@",json);
        _animateView.timeLineView.hidden = YES;
        _animateView.titleImageView.hidden = NO;
        if([json[@"code"] isEqualToString:@"100"]){
            _animateView.timeLineView.hidden = NO;
            _animateView.titleImageView.hidden = YES;
            //服务器判断
            _animateView.timeLineView.dataArray = json[@"resultList"];//先传

            //手机端判断
            /*
             //服务器时间
            long long serverSystemTime = [json[@"systime"] longLongValue];
            _animateView.timeLineView.isThirdData = YES;
            _animateView.timeLineView.dataArray = json[@"resultList"];//先传
            NSLog(@"手机当前时间 == %f 服务器系统时间 == %lld 两个时间之差 = %Lf",[[NSDate date] timeIntervalSince1970],serverSystemTime,fabsl((long double)([[NSDate date] timeIntervalSince1970] - serverSystemTime)));
            
            if(fabsl((long double)([[NSDate date] timeIntervalSince1970] - serverSystemTime)) > 58){
                ZHLog(@"手机的当前时间不准确, 传服务器时间");
                NSDate  *serverSystemDate = [NSDate dateWithTimeIntervalSince1970:serverSystemTime];
                _animateView.timeLineView.currentDate = serverSystemDate;
            }else{
                ZHLog(@"手机的当前时间准确， 传手机系统时间");
                _animateView.timeLineView.currentDate = [NSDate date];
            }
             */
        }
    } failure:^(NSError *error) {
        _animateView.timeLineView.hidden = YES;
        _animateView.titleImageView.hidden = NO;
        ZHLog(@"%@",error);
    }];
}
#pragma mark -- （1）剩余饺子数
/**
 *  剩余饺子数
 */
- (void)loadDataRemainingDumplingWithNumber{
    [self showHudInView:self.view hint:@"正在加载"];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool currentDumplingWithNumberProductCode:ProductCode sysType:SysType andSessionValue:SessionValue]success:^(id json) {
        ZHLog(@"%@",json);
        [self hideHud];
        if([json[@"code"] isEqualToString:@"100"]){
            RemainingDumplingNumberModel *remainingModel = [RemainingDumplingNumberModel remainingDumplingNumberModelWithDic:(NSDictionary *)json];
            _animateView.number = [remainingModel.switchAndNumModel.num intValue];
            _timeup = [remainingModel.switchAndNumModel.timeup intValue];
            _vote = [remainingModel.switchAndNumModel.vote intValue];
            //调试
//            _vote = 1;
//            _timeup = 1;
            
            _voteView.hidden = _vote ? NO : YES;
            _voteUrl = [NSString stringWithFormat:@"%@",remainingModel.switchAndNumModel.voteUrl];
            [_animateView startTimer];
            if(LYLIsLoging){//已登陆
                [self loadDataAdvertisingList];
//                [self loadDataUserDumplingList];//请求获奖信息列表  写后边

            }else{
                [self loadDataNoLoginStatusMaxNumber];//获取未登录捞饺子上限
            }
        }else{
            [LYLTools showInfoAlert:@"服务器挤爆了，稍后再来哦"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [LYLTools showInfoAlert:@"服务器挤爆了，稍后再来哦"];
        ZHLog(@"%@",error);
    }];
}

/**
 {“code”:  101 系统错误
 “message”:”There’s an error.” //错误说明
 }
 展示捞奖次数不足，领取失败，提示可以换个手机号领取
 {“code”:  102 //展示捞奖次数不足
 “message”:” 领取失败，提示可以换个手机号领取.” //失败说明
 }
 
 {“code”:  103 登陆失败
 “message”:”” // 验证码错误 注册失败
 }
 {“code”:  104 //饺子已过期
 “message”:” 饺子已过期” //失败说明
 }
 {““code”:  105 //饺子已被领取
 “message”:” 饺子已被领取.” //失败说明
 }
 {“code”:  106//参数不正确
 “message”:” 参数不正确” //失败说明
 }
 {“code”:  107//饺子配置规则缓存无数据
 “message”:” 饺子配置规则缓存无数据” //失败说明
 }
 {“code”:  108 //用户饺子配置规则缓存无数据
 “message”:” 用户饺子配置规则缓存无数据” //失败说明
 }
 {“code”:  109 //饺子缓存为空
 “message”:” 饺子缓存为空” //失败说明
 }
 */
#pragma mark -- 调用领取接口
-(void)loadDataWithNoLoginGetMoney{
    
    //未登录饺子存储的饺子
    NSMutableArray *dumplingIdArray = [LYLTools noGetMeoneyWithReturnDumplingId];//未登录没有领取的饺子
    if(dumplingIdArray.count > 0){
        NSString *dumplingStr =  [dumplingIdArray componentsJoinedByString:@","];
        [self showHudInView:self.view hint:@"正在领取。。。"];
        [LYLAFNetWorking getWithBaseURL:[LYLHttpTool noLogingGetMoneyWithProductCode:ProductCode sysType:SysType sessionValue:SessionValue phone:MyObjectForKey(LoginPhoneKey)  prizeidList:dumplingStr andUserId:MyObjectForKey(UserIDKey)] success:^(id json) {
            ZHLog(@"%@",json);
            [self hideHud];
            
            switch ([[json objectForKey:@"code"] intValue]) {
                case 100://领取成功
                {
                    [self showHint:@"领取成功"];
                    [[ZHDataBase sharedDataBase]upDataWithNoLogingFromlogingState:@"0" toLogingState:@"1" andUserId:LYLUserId];
                }
                    break;
                case 101:
                {
                    [LYLTools showInfoAlert:@"系统错误"];
                }
                    break;
                case 102:
                {
                    [LYLTools showInfoAlert:@"领取失败，可以换个手机号领取"];
                }
                    break;
                case 103:
                {
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [LYLTools showInfoAlert:@"登陆失败"];
                }
                    break;
                case 104:
                {
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [LYLTools showInfoAlert:@"饺子已过期"];
                }
                    break;
                case 105:{
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];

                    [LYLTools showInfoAlert:@"饺子已被领取"];
                }
                    break;
                    
                case 106:
                {
                    //                [Tools showInfoAlert:@"参数不正确"];
                }
                    break;
                case 107:
                case 108:
                case 109:{
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [LYLTools showInfoAlert:@"饺子信息无效"];
                }
                    break;
                default:
                    break;
            }
            [[NoGetMoneyView shareGetMoneyView] refreshShareGetMoneyView];//刷新捞一捞界面未领取金额的数据
            
        } failure:^(NSError *error) {
            ZHLog(@"%@",error);
            [self hideHud];
            
        }];
    }
}

@end
