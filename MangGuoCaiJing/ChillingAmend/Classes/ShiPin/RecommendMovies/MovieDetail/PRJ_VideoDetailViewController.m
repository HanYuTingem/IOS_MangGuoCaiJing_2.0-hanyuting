//
//  PRJ_VideoDetailViewController.m
//  ChillingAmend
//
//  Created by svendson on 14-12-23.
//  Copyright (c) 2014年 SinoGlobal. All rights reserved.
//

#import "PRJ_VideoDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GTMBase64.h"
#import "LoginViewController.h"
#import "PRJ_VideoListModel.h"
#import "TimeStringTransform.h"
#import "UITapGestureRecognizer+KTapGesture.h"
#import <AVFoundation/AVFoundation.h>
#import "playerView.h"
#import "ADAudioView.h"
#import "RefreshNetworkView.h"
#import "CZJudgeNetWork.h"
#import "LMDotIndicatorView.h"

@interface PRJ_VideoDetailViewController ()<MPMediaPickerControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate ,RefreshNetWorkDelegate>

{
    MPMoviePlayerViewController *moviePlayer;  //播放器
    int count;     //用于判断是否快进或者快退
    NSString *record;   //是否观看过此视频
    int page ;       //上拉加载当前页数
    BOOL zanOrCollect;  //判断是赞还是收藏
    int isFirstIn;    //判断是否是第一次进入此页面 用于是否需要加载圈
}
/**
 *videoImage               视屏展示图片
 *contentBgScrollView      简介背景可滑动
 *contentBgView            简介背景
 *titleLabel               标题
 *priceLabel               奖励积分
 *noSingalView             无网络提示
 *yinDaoYeView             引导页
 *tuiJianView              推荐视图背景
 */


@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIScrollView *contentBgScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIView *noSingalView;
@property (strong, nonatomic) IBOutlet UIView *yinDaoYeView;
@property (strong, nonatomic) IBOutlet UIView *tuiJianView;
//视频简介
@property (weak, nonatomic) IBOutlet UIWebView *detailView;
//视频地址
@property (nonatomic, strong) NSString *videoUrl;
//赞的数量
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
//赞的显示图片
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
//收藏的显示图片
@property (weak, nonatomic) IBOutlet UIImageView *collectionView;
//分享的显示图片
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
//点赞收藏的提示框
@property (nonatomic, strong)  UIView *messageView;
//引导页上的显示的积分
@property (weak, nonatomic) IBOutlet UILabel *yinDaoYeLaJiaoBiCount;
//推荐视频滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *tuiJianScrollView;
//奖励积分View
@property (weak, nonatomic) IBOutlet UIView *coinView;
//是否已看过
@property (weak, nonatomic) IBOutlet UILabel *weitherWatch;
//推荐视频未看过的视频集合
@property (nonatomic , strong) NSMutableArray *tuiJianArray;

//列表
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//页面所有按钮
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
//已看过视频集合
@property (nonatomic, strong) NSMutableArray *haveLookedMovies;


/** 现在滚动到了第几个时间轴 */
@property (nonatomic, unsafe_unretained) int timeLineCount;
/** 判断是否能旋转 */
@property (nonatomic, assign) BOOL canRotate;
/** 十个像素的条，为了适配UI */
@property (nonatomic, strong) UIView* smallBar;
@property (nonatomic, weak) RefreshNetworkView* notNetWorkView;
@property (nonatomic, assign, getter=isShowNoNetView) BOOL netWorkViewShow;
/** 网络状态 */
@property (nonatomic, copy) NSString* netWorkInfo;
/** 没有数据的 大的 View */
@property (nonatomic, weak) UIView* noDataView;
@property (nonatomic, assign, getter=isShowNoDataView) BOOL noDataViewShow;
/** 加载数据的时候的...窗口 */
@property (nonatomic, strong) LMDotIndicatorView* dotIndicator;

@end

@implementation PRJ_VideoDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    //无网络添加
    int netType = [GCUtil getNetworkTypeFromStatusBar];
    if ( netType != 0 ) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            [self.view addSubview:self.yinDaoYeView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeYindaoYe)];
            [self.yinDaoYeView addGestureRecognizer:tap];
            
            UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeYindaoYe)];
            swip.direction = UISwipeGestureRecognizerDirectionLeft;
            [self.yinDaoYeView addGestureRecognizer:swip];
            self.coinView.hidden = YES;
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
            [self showMsg:nil];
        }
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
        mainRequest.tag = 100;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTheVideos:)];
        [self.videoImage addGestureRecognizer:tap];
    } else {
        [self.contentBgScrollView addSubview:self.noSingalView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTheDatas:)];
        [self.noSingalView addGestureRecognizer:tap];
    }
    
//    if (self.playerV.showHeadAD) {
////        self.playerV.headImgCountDownTime = [NSNumber numberWithInt:self.videoHeadModel.IMAGE_TIME.intValue];
//        self.playerV.headImgCountDownTime = [NSNumber numberWithInt:20];
//    }
}

- (void)willResignActive
{
    self.playerV.continueTime = self.playerV.moviePlayer.moviePlayer.currentPlaybackTime;
    [self.playerV timerStop];
}

- (void)willEnterToForeground
{
    //判断网络
    self.netWorkInfo = [CZJudgeNetWork networkInfo];
    //没有网络
    if ([self.netWorkInfo isEqualToString:@"NoNetWork"]) {
        //        self.showNetWorkView = YES;
        [self.view addSubview:self.notNetWorkView];
        self.netWorkViewShow = YES;
        self.canRotate = NO;
    }
    else {
        //隐藏无网络窗口
        if (self.isShowNoNetView) {
            [self.notNetWorkView removeFromSuperview];
            self.netWorkViewShow = NO;
        }
        [self.playerV pause];
        self.playerV.playPlayingState = YES;
        self.playerV.gestureView.hidden = YES;
        
        self.playerV.playBtn.hidden = NO;
        //更新下放广告view高度
//        [self updateBackgroundScrollHeight];
//        self.bottomScrollView.contentSize = CGSizeMake(AD_BUTTON_WIDTH * [self.adButtons count] + 10, self.bottomScrollView.frame.size.height);
//        self.rightScrollView.contentSize = CGSizeMake(self.rightScrollView.frame.size.width, (AD_BUTTON_HEIGHT + 38) * [self.rightADbuttons count] + 13);
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterToForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self willEnterToForeground];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.playerV.adAudioView.hidden = YES;
    if (self.playerV.moviePlayer.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self.playerV pause];
    }
    
    [self.playerV hideMessage];
//    [self.playerV timerStop];
//    self.playerV.continueTime = self.playerV.moviePlayer.moviePlayer.currentPlaybackTime;
    
    [self.playerV showHeadAndFootView:NO];
    [self.playerV.headImgCountDownTimer invalidate];
    self.playerV.headImgCountDownTimer = nil;
    [self willResignActive];
    
    [super viewWillDisappear:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    for (UIButton *btn in self.allButtons) {
        //去除多个button同事点击的效果
        [btn setExclusiveTouch:YES];
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.bar.alpha = 0.1;
    
    isFirstIn = 0;
    
    NSLog(@"---------------%@",self.videoID);
    page = 1;
    zanOrCollect = NO;
    self.tuiJianArray = [[NSMutableArray alloc] init];
    self.haveLookedMovies = [[NSMutableArray alloc] init];
    self.detailDic = [[NSDictionary alloc] init];
    //    [self setNavigationBarWithState:1 andIsHideLeftBtn:NO andTitle:@""];
    //    self.bar.backgroundColor = [UIColor clearColor];
    self.bar.hidden = YES;
    
    count = 0;
    self.detailView.backgroundColor = [UIColor clearColor];
    self.detailView.opaque = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardingTargetAndBackForarding:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    //刷新加载
    [self addHeader];
    [self addFooter];
    
    [self setPlayerView];
    
    RefreshNetworkView* refreshView = [[RefreshNetworkView alloc] initWithFrame:self.view.frame];
    refreshView.delegate = self;
    self.notNetWorkView = refreshView;
    [self judgeNectWorkSatae];
    if ([self.netWorkInfo isEqualToString:@"NoNetWork"]) {
        self.netWorkViewShow = YES;
        [self.view addSubview:self.notNetWorkView];
        self.canRotate = NO;
    }
    else {
        if (self.isShowNoNetView) {
            [self.notNetWorkView removeFromSuperview];
            self.netWorkViewShow = NO;
        }
        [self.notNetWorkView removeFromSuperview];
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
        mainRequest.tag = 100;
        [self.playerV pause];
        self.playerV.playPlayingState = NO;
        self.canRotate = YES;
    }
    
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 12, 20)];
    [self.backBtn setImage:[UIImage imageNamed:@"videodetails_title_btn_back.png" ] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPlayerView {
    self.playerV = [[playerView alloc] init];
    self.playerV.frame = CGRectMake(0, 20, self.view.bounds.size.width, 180 * self.view.frame.size.width / 320);
//    self.playerV = [playerView Instence];
    [self.playerV setObjects];
    [self.view addSubview:self.playerV];
    
    //添加一个10像素的uiview以适应UI
    self.smallBar = [[UIView alloc]
                     initWithFrame:CGRectMake(0, self.playerV.bounds.size.height + 20,
                                              self.view.frame.size.width, 5)];
    self.smallBar.backgroundColor = FXQColor(239, 239, 239);
    [self.view addSubview:self.smallBar];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
            selector:@selector(deviceRotated)
                name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [self.playerV adHIdden];
    self.timeLineCount = 0;
    self.canRotate = YES;
}

- (void)playVideo:(NSString*)strURL
{
    self.playerV.playerURL = strURL;
}

/** 设备旋转 */
- (void)deviceRotated
{
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.smallBar.hidden = YES;
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationPortrait) {
        self.smallBar.hidden = NO;
    }
}

/** 解析出来的数据添加给View */
- (void)showModel
{
    [self setHeadAD];
    [self.playerV adHIdden];
    //绑定视频及前置广告信息
    [self.playerV.beginImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",img_url,self.detailDic[@"video_img"]]] placeholderImage:[UIImage imageNamed:@"defaultimgmall_banner_bg_img.png"]];
    self.playerV.headView.titleLabel.text = self.detailDic[@"video_name"];
//    [self.playerV.beginImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ABaseUrl,self.latestModel.VIDEO_IMAGE_URL]]];
//    self.playerV.headView.titleLabel.text = self.latestModel.VIDEO_NAME;
    if (self.playerV.isShowHeadAD == YES) {
        switch (self.playerV.headADType) {
                //前置广告是视频
            case 0:
                if (self.detailDic[@"ad_video"]) {
                    [self playVideo:self.detailDic[@"ad_video"]];
                }
                break;
                //前置广告是图片
            case 1:
                if (self.detailDic[@"ad_img"]) {
                    [self.playerV.headAdImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",img_url,self.detailDic[@"ad_img"]]]];
                    NSString *ad_time = self.detailDic[@"ad_img_time"];
                    self.playerV.headImgCountDownTime = [NSNumber numberWithInteger:ad_time.integerValue];
                }
                break;
            default:
                break;
        }
    }else {
        [self playVideo:self.detailDic[@"video_url"]];
    }

}
#pragma mark - 前置后置广告
/** 设置广告类型 */
- (void)setHeadAD
{
    self.playerV.showHeadAD = YES;
    
    if (self.detailDic[@"ad_video"] && ![self.detailDic[@"ad_video"] isEqualToString:@""]) {
        self.playerV.headADType = 0;
    }else if (self.detailDic[@"ad_img"] &&![self.detailDic[@"ad_img"] isEqualToString:@""]) {
        self.playerV.headADType = 1;
    }else {
        self.playerV.showHeadAD = NO;
    }
}

#pragma mark - 没有网络代理方法
- (void)judgeNectWorkSatae
{
    self.netWorkInfo = [CZJudgeNetWork networkInfo];
}
- (void)refreshNetWork
{
    [self judgeNectWorkSatae];
    if ([self.netWorkInfo isEqualToString:@"NoNetWork"]) {
        
    }else {
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
        mainRequest.tag = 100;
    }
}

#pragma mark - 广告页面
//建立下方广告
- (void)createAdvertiment
{
    //右侧弹出广告
    if (SHOW_RIGHT_AD) {
        RightPopADView* rightPopADView = [RightPopADView createRPAV];
        
        self.playerV.rightPopADView = rightPopADView;
        [self.playerV addSubview:self.playerV.rightPopADView];
        [self.playerV hideRightView];
        [self setADViewFrame];
//        [self setADScrollViewFrame];
        //配置右侧弹出广告页面的文字信息
        [self prepareADView];
    }
//    if (SHOW_BOTTOM_AD) {
//        
//        //竖屏下方广告
//        if (!self.bottomADTableView) {
//            self.bottomADTableView = [ZXADTableView createADTableView];
//        }
//        [self.backgroundScrollView addSubview:self.bottomADTableView];
//        [self setADViewFrame];
//        [self.bottomADTableView updateTableHeight];
//        
//        //设置竖屏页面下方滚动条
//        [self setADScrollViewFrame];
//    }
}

/** 配置右侧弹出广告页面的文字信息*/
- (void)prepareADView
{
}

#pragma mark 布局
////设置滚动广告条
//- (void)setADScrollViewFrame
//{
//    if (SHOW_BOTTOM_AD) {
//        if (!self.bottomScrollView) {
//            self.bottomScrollView = [[UIScrollView alloc] init];
//        }
//        
//        //竖屏下方广告
//        self.bottomScrollView.frame = CGRectMake(0, 10, self.bottomADTableView.frame.size.width,
//                                                 self.bottomADTableView.bottomADScrollView.frame.size.height);
//        self.bottomScrollView.contentSize = CGSizeMake(0, 0);
//        self.bottomScrollView.backgroundColor = [UIColor whiteColor];
//        [self.backgroundScrollView addSubview:self.bottomScrollView];
//    }
//    
//    if (SHOW_RIGHT_AD) {
//        if (!self.rightScrollView) {
//            self.rightScrollView = [[UIScrollView alloc] init];
//        }
//        //横屏右侧广告
//        self.rightScrollView.frame = CGRectMake(0, 0, 110, self.view.frame.size.width);
//        self.rightScrollView.backgroundColor = [UIColor clearColor];
//        self.bottomScrollView.showsHorizontalScrollIndicator = NO;
//        self.rightScrollView.showsVerticalScrollIndicator = NO;
//        
//        [self.playerV.rightPopADView addSubview:self.rightScrollView];
//    }
//}

- (void)setADViewFrame
{
    if (SHOW_RIGHT_AD) {
        CGRect rightFrame = CGRectMake(self.view.frame.size.height, 0, 267,
                                       self.view.frame.size.width);
        //横屏右侧广告
        self.playerV.rightPopADView.frame = rightFrame;
    }
    
//    if (SHOW_BOTTOM_AD) {
//        CGRect bottomFrame = CGRectMake(0, 14, self.view.frame.size.width, self.backgroundScrollView.frame.size.height - 50); //这里-14而不是15是因为表的header一定要是1
//        //竖屏下方广告
//        self.bottomADTableView.frame = bottomFrame;
//    }
}

- (void)setButtonsFrame
{
    //设置广告button
//    for (int i = 0; i < [self.adButtons count]; i++) {
//        CGRect buttonFrame;
//        //横向
//        buttonFrame = CGRectMake(5 + AD_BUTTON_WIDTH * i, 10, AD_BUTTON_WIDTH,
//                                 AD_BUTTON_HEIGHT);
//        ZXADButton* tempBtn = self.adButtons[i];
//        tempBtn.frame = buttonFrame;
//        [self.bottomScrollView addSubview:tempBtn];
//    }
//    for (int i = 0; i < [self.rightADbuttons count]; i++) {
//        //纵向
//        CGRect buttonFrame;
//        ZXADButton* tempBtn = self.rightADbuttons[i];
//        buttonFrame = CGRectMake(5, 13 + (AD_BUTTON_HEIGHT + 38) * i,
//                                 AD_BUTTON_WIDTH, AD_BUTTON_HEIGHT); //这里的38是label1的间距+label1的高度加上label2的间距和label2的高度，加上按钮的间距。4+11+5+11+7
//        tempBtn = self.rightADbuttons[i];
//        tempBtn.frame = buttonFrame;
//        
//        [self.rightScrollView addSubview:tempBtn];
//        UILabel* tempLabel = [[UILabel alloc]
//                              initWithFrame:CGRectMake(5, buttonFrame.origin.y + AD_BUTTON_HEIGHT + 4, self.rightScrollView.frame.size.width - 10, 11)];
//        tempLabel.textAlignment = NSTextAlignmentLeft;
//        tempLabel.textColor = FXQColor(255, 255, 255);
//        [tempLabel setFont:[UIFont systemFontOfSize:11]];
//        tempLabel.text = @"何当共剪西窗烛";
//        UILabel* tempLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, tempLabel.frame.origin.y + tempLabel.frame.size.height + 5, self.rightScrollView.frame.size.width - 10, 11)];
//        tempLabel2.font = [UIFont systemFontOfSize:11];
//        tempLabel2.textAlignment = NSTextAlignmentLeft;
//        tempLabel2.textColor = FXQColor(255, 255, 255);
//        tempLabel2.text = @"却话巴山夜雨时";
//        
//        [self.rightScrollView addSubview:tempLabel2];
//        [self.rightScrollView addSubview:tempLabel];
//    }
//    self.bottomScrollView.contentSize = CGSizeMake(AD_BUTTON_WIDTH * [self.adButtons count] + 10, self.bottomScrollView.frame.size.height);
//    self.rightScrollView.contentSize = CGSizeMake(self.rightScrollView.frame.size.width, (AD_BUTTON_HEIGHT + 38) * [self.rightADbuttons count] + 13);
}

/**
 *  设置包含广告按钮的scrollview
 */
//- (void)setADButtonsWithImage
//{
//    //横向
//    for (ZXADButton* tempbtn in self.adButtons) {
//        [tempbtn removeFromSuperview];
//    }
//    self.adButtons = [[NSArray alloc] init];
//    for (int i = 0; i < [self.adImagesURL count]; i++) {
//        ZXADButton* imageButton = [ZXADButton createButton];
//        imageButton.frame = CGRectMake(0, 0, 100, 80);
//        [imageButton addTarget:self
//                        action:@selector(touchAdImage:)
//              forControlEvents:UIControlEventTouchUpInside];
//        if ([self.adImagesURL[i] isEqual:@""] || !self.adImagesURL[i] || [self.adImagesURL[i] isEqual:[NSNull null]]) {
//            [imageButton.backgroundImageView setImage:[UIImage imageNamed:@"public_list_img_commodity_default"]];
//        }
//        else {
//            [imageButton.backgroundImageView
//             setImageWithURL:[NSURL URLWithString:self.adImagesURL[i]]
//             placeholderImage:[UIImage
//                               imageNamed:@"public_list_img_commodity_load"]];
//        }
//        [imageButton setState:0];
//        imageButton.maskImageView.hidden = NO;
//        if (i + 1 >= 10) { //加1是因为i从0开始
//            imageButton.numberLabel.text = [NSString stringWithFormat:@"%zd", i + 1];
//        }
//        else {
//            imageButton.numberLabel.text = [NSString stringWithFormat:@"0%zd", i + 1];
//        }
//        //        imageButton.enabled = NO;
//        self.adButtons = [self.adButtons arrayByAddingObject:imageButton];
//    }
//    //纵向
//    int index = 0;
//    for (ADModel* tempModel in self.adModelArr) { //取出商家广告的model
//        NSMutableArray* tempArr = [[NSMutableArray alloc] init];
//        index++;
//        for (LMTicketModal* tempCellModel in tempModel.tjq) { //取出特价券中的每个券
//            //建立按钮 并将图片绑定给按钮
//            NSString* tempImgStr = tempCellModel.img;
//            [self.rightPopImages addObject:tempImgStr];
//            [self.rightPopIDs addObject:tempCellModel.coupon_id];
//            
//            ZXADButton* rightButton = [ZXADButton createButton];
//            rightButton.frame = CGRectMake(0, 0, 100, 80);
//            [rightButton addTarget:self
//                            action:@selector(tapRightAD:)
//                  forControlEvents:UIControlEventTouchUpInside];
//            
//            if ([tempImgStr isEqual:@""] || !tempImgStr || [tempImgStr isEqual:[NSNull null]]) {
//                [rightButton.backgroundImageView setImage:[UIImage imageNamed:@"public_list_img_commodity_load"]];
//            }
//            else {
//                [rightButton.backgroundImageView
//                 setImageWithURL:[NSURL URLWithString:tempImgStr]
//                 placeholderImage:
//                 [UIImage imageNamed:@"public_list_img_commodity_load"]];
//            }
//            [rightButton setState:0];
//            rightButton.maskImageView.backgroundColor = [UIColor whiteColor];
//            rightButton.maskImageView.hidden = NO;
//            rightButton.maskImageView.alpha = 0.6;
//            //如果是第一张特价券，就加上序号标签
//            if ([tempModel.tjq indexOfObject:tempCellModel] == 0) {
//                if (index + 1 >= 10) { //加1是因为i从0开始
//                    rightButton.numberLabel.text =
//                    [NSString stringWithFormat:@"%zd", index];
//                }
//                else {
//                    rightButton.numberLabel.text =
//                    [NSString stringWithFormat:@"0%zd", index];
//                }
//            }
//            else {
//                [rightButton.numberLabel removeFromSuperview];
//                [rightButton.numberBackgroundView removeFromSuperview];
//                //                rightButton.numberLabel.hidden = YES;
//            }
//            //将按钮写入数组1，并写入数组2的子数组
//            [self.rightADbuttons addObject:rightButton];
//            [tempArr addObject:rightButton];
//        }
//        //将子数组写入数组2
//        [self.rightButton addObject:tempArr];
//    }
//    //设置按钮位置
//    [self setButtonsFrame];
//}
//
#pragma mark 交互

/**
 *  判断广告按钮是不是可用
 */
- (void)adImageVisible
{
    if (![self.playerV isShowHeadAD]) {
        NSTimeInterval currentTime =
        [self.playerV.moviePlayer.moviePlayer currentPlaybackTime];
        [self adimageVisibleByTime:currentTime];
    }
}

/** 根据时间判断广告是否可见 */
- (void)adimageVisibleByTime:(double)time
{
//    // 每次调用就延长一点contentSize，如果出去了 就移动contentSize
//    for (int i = 0; i < [self.adImagesURL count]; i++) {
//        NSString* playtimeStr = self.adTimes[i];
//        if (time >= [playtimeStr doubleValue]) {
//            //如果没有被显示 就显示按钮和网页 并延长scrollView
//            if ([self.isShowed[i] isEqualToString:@"N"]) {
//                //移动scroll view
//                [self moveScrollViewContent];
//                [self setButtonsStateWithIndex:i];
//                int start = 0, end = 0;
//                for (int j = 0; j < self.timeLineCount - 1; j++) {
//                    start = start + (int)[self.rightButton[j] count];
//                }
//                end = start + (int)[self.rightButton[self.timeLineCount - 1] count];
//                for (int j = start; j < end; j++) {
//                    [self highlightRightBtn:j];
//                }
//                //标注为已展示
//                self.isShowed[i] = @"Y";
//                //                [self.playerV showRightPopBtn];
//                [self.playerV.headView.popADButton setTitleColor:FXQColor(202, 48, 130)
//                                                        forState:UIControlStateNormal];
//            }
//        }
//        else {
//            break;
//        }
//    }
}

///** 添加scroll view的content的长度，并自动滚动 */
//- (void)moveScrollViewContent
//{
//    //横向滚动
//    CGFloat offsetX = self.timeLineCount * AD_BUTTON_WIDTH + self.bottomScrollView.frame.size.width;
//    CGFloat contentWidth = self.bottomScrollView.contentSize.width;
//    //若移动值+屏幕宽度大于contentSize，就会滚动太多，要这里加判断
//    if (offsetX < contentWidth) {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.bottomScrollView.contentOffset = CGPointMake(self.timeLineCount * AD_BUTTON_WIDTH, 1);
//                         }];
//    }
//    else {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.contentSize.width - self.bottomScrollView.frame.size.width, 1);
//                         }];
//    }
//    
//    //纵向滚动
//    int hOffset = 0;
//    for (int i = 0; i < self.timeLineCount; i++) {
//        ADModel* tempModel = self.adModelArr[i];
//        int speicalCount = (int)tempModel.tjq.count;
//        //有广告且rightPopView不在屏幕内的时候弹出headview和footview
//        if (speicalCount && self.playerV.rightPopADView.frame.origin.x >= self.playerV.frame.size.width && self.playerV.portraitBool == NO) {
//            [self.playerV showHeadAndFootView:YES];
//        }
//        hOffset = hOffset + speicalCount * (AD_BUTTON_HEIGHT + 38);
//    }
//    //判断是不是滚动的太多
//    if (hOffset + self.rightScrollView.frame.size.height < self.rightScrollView.contentSize.height) {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.rightScrollView.contentOffset = CGPointMake(0, hOffset);
//                         }];
//    }
//    else {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.rightScrollView.contentOffset = CGPointMake(0, self.rightScrollView.contentSize.height - self.rightScrollView.frame.size.height);
//                         }];
//    }
//    self.timeLineCount++;
//}

///** 右侧按钮加框 */
//- (void)selectRightADBtn:(NSInteger)index
//{
//    ZXADButton* btn = self.rightADbuttons[index];
//    [btn setState:2];
//    for (int i = 0; i < [self.rightADbuttons count]; i++) {
//        if (i != index) {
//            //            btn = self.playerV.rightPopADView.btnArray[index];
//            //            [btn setState:0];
//            btn = self.rightADbuttons[i];
//            [btn setState:0];
//        }
//    }
//}

///** 根据index高亮右侧按钮 */
//- (void)highlightRightBtn:(NSInteger)index
//{
//    ZXADButton* btn = self.rightADbuttons[index];
//    //    btn = self.playerV.rightPopADView.btnArray[index];
//    btn.maskImageView.hidden = YES;
//}
//
///** 点击广告按钮 更新竖屏广告 */
//- (IBAction)touchAdImage:(id)sender
//{
//    NSInteger index;
//    UIButton* button = (UIButton*)sender;
//    if ([self.adButtons containsObject:button]) {
//        index = [self.adButtons indexOfObject:button];
//    }
//    [self selectADButton:index];
//}
//
///** 点击右侧广告 */
//- (IBAction)tapRightAD:(id)sender
//{
//    NSInteger index;
//    UIButton* button = (UIButton*)sender;
//    index = [self.rightADbuttons indexOfObject:button];
//    [self displayRightAD:index];
//    [self selectRightADBtn:index];
//}
//
/** 竖屏根据Index显示下方广告 */
- (void)setDisplayADWithIndex:(NSInteger)index
{
}

/** 横屏根据index显示广告 */
- (void)displayRightAD:(NSInteger)index
{
}

///** 根据index高亮横向滚动条按钮 */
//- (void)setButtonsStateWithIndex:(NSInteger)index
//{
//    ZXADButton* bottomBtn = self.adButtons[index];
//    bottomBtn.maskImageView.hidden = YES;
//}
///** 竖屏广告按钮选中状态 */
//- (void)selectADButton:(NSInteger)index
//{
//    ZXADButton* bottomBtn = self.adButtons[index];
//    [bottomBtn setState:1];
//    for (ZXADButton* tempBtn in self.adButtons) {
//        if (![tempBtn isEqual:bottomBtn]) {
//            [tempBtn setState:0];
//        }
//    }
//    [self setDisplayADWithIndex:index];
//}

///** 根据index设置竖向按钮高亮 */
//- (void)setRightBtnState:(NSInteger)index
//{
//    
//    ZXADButton* rightBtn = self.rightADbuttons[index];
//    [rightBtn setState:2];
//    for (int i = 0; i < [self.rightADbuttons count]; i++) {
//        if (i != index) {
//            rightBtn = self.rightADbuttons[i];
//            [rightBtn setState:0];
//        }
//    }
//}

//请让rootVC支持canRotate方法，然后可以让这个VC支持旋转。
//关于这段代码的解释的传送门：
// http://www.sebastianborggrewe.de/only-make-one-single-view-controller-rotate/
- (BOOL)canRotate
{
    return _canRotate;
}


#pragma mark - 刷新
- (void)addHeader
{
    __unsafe_unretained PRJ_VideoDetailViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.myTableView;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        //        isEndLoadData = NO;
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        self.tuiJianArray = [@[] mutableCopy];
        self.haveLookedMovies = [@[] mutableCopy];
        page = 1;
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI recommendedVideoUserId:kkUserCenterId andSize:@"6" andpage:[NSString stringWithFormat:@"%d",page] andPlayingVideoID:self.videoID]];
        mainRequest.tag = 150;
        [self showMsg:nil];
        
    };
    _header = header;
}

- (void)addFooter
{
    __unsafe_unretained PRJ_VideoDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.myTableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        page ++;
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI recommendedVideoUserId:kkUserCenterId andSize:@"6" andpage:[NSString stringWithFormat:@"%d",page] andPlayingVideoID:self.videoID]];
        mainRequest.tag = 150;
        [self showMsg:nil];
    };
    _footer = footer;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *cellIdentiFier = @"resueCell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:cellIdentiFier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentiFier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setTheTuiJianViewWithCell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tuiJianArray.count == 0) {
        if (self.haveLookedMovies.count % 2 == 0) {
            return (self.haveLookedMovies.count / 2 ) * 126 + (self.haveLookedMovies.count / 2 ) * 10 - 5;
        } else {
            return (self.haveLookedMovies.count / 2 + 1 )* 126 + (self.haveLookedMovies.count / 2 + 1 ) * 10 - 5;
        }
    } else {
        if (self.tuiJianArray.count % 2 == 0) {
            return (self.tuiJianArray.count / 2 ) * 126 + (self.tuiJianArray.count / 2 ) * 10 - 5;
        } else {
            return (self.tuiJianArray.count / 2 + 1 )* 126 + (self.tuiJianArray.count / 2 + 1 ) * 10 - 5;
        }
    }
}

- (void)setTheTuiJianViewWithCell:(UITableViewCell *)cell
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if (self.tuiJianArray.count <= 1) {
        tempArr = self.haveLookedMovies;
    } else {
        tempArr = self.tuiJianArray;
    }
    if (tempArr.count > 0) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        for (int i = 0; i < tempArr.count; i ++) {
            
            PRJ_VideoListModel *listModel = tempArr[i];
            
            UIView *lanMuView = [[UIView alloc] initWithFrame:CGRectMake(10 + (i % 2) * ( (300) / 2 +5),  10 + (i / 2) * 130, 300 / 2 , 120)];
            lanMuView.userInteractionEnabled = YES;
            [lanMuView setExclusiveTouch:YES];
            lanMuView.tag = i;
            
            //视屏图片
            UIImageView *lanMuImageView = [[UIImageView alloc] init];
            lanMuImageView.userInteractionEnabled = YES;
            [lanMuImageView sd_setImageWithURL:[NSURL URLWithString:listModel.videoImage] placeholderImage:[UIImage imageNamed:@"defaultimgvideo_list_img1.png"]];
            
            lanMuImageView.frame = CGRectMake(0, 0, 145, 79);
            
            //底部黑色透明背景
            UIImageView *bootomBg = [[UIImageView alloc] init];
            bootomBg.image = [UIImage imageNamed:@"videohome_gallery_bg.png"];
            bootomBg.frame = CGRectMake(0, 62, 145, 17);
            
            //底部金钱图片
            UIImageView *moneyView = [[UIImageView alloc] init];
            moneyView.image = [UIImage imageNamed:@"videolist_list_ico.png"];
            moneyView.frame = CGRectMake(7, 66, 12, 10);
            
            //金币数量
            UILabel *mingChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 63, 75, 15)];
            mingChengLabel.textColor = [UIColor whiteColor];
            mingChengLabel.backgroundColor = [UIColor clearColor];
            mingChengLabel.font = [UIFont systemFontOfSize:10.0];
            
            mingChengLabel.text = listModel.videoJiFen;
            mingChengLabel.textAlignment = NSTextAlignmentLeft;
            
            //视屏时长
            UILabel *timeChengLabel = [[UILabel alloc] initWithFrame:CGRectMake(145 - 81, 63, 75, 15)];
            timeChengLabel.backgroundColor = [UIColor clearColor];
            timeChengLabel.font = [UIFont systemFontOfSize:10.0];
            timeChengLabel.textColor = [UIColor whiteColor];
            //            NSString *time = [TimeStringTransform getTimeString:listModel.VideoDuration];
            //            NSArray *timeARR = [time componentsSeparatedByString:@" "];
            timeChengLabel.text = listModel.VideoDuration;
            timeChengLabel.textAlignment = NSTextAlignmentRight;
            
            //文字简介
            UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 145, 17)];
            TitleLabel.backgroundColor = [UIColor clearColor];
            TitleLabel.font = [UIFont systemFontOfSize:13.0];
            TitleLabel.text = listModel.videoName;
            TitleLabel.textAlignment = NSTextAlignmentLeft;
            
            // 副标题文字简介
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 101, 145, 18)];
            detailLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.font = [UIFont systemFontOfSize:11.0];
            detailLabel.text = listModel.videosubTitle;
            detailLabel.textAlignment = NSTextAlignmentLeft;
            
            [lanMuView addSubview:lanMuImageView];
            [lanMuView addSubview:bootomBg];
            [lanMuView addSubview:moneyView];
            [lanMuView addSubview:timeChengLabel];
            [lanMuView addSubview:TitleLabel];
            [lanMuView addSubview:detailLabel];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideoIndetaiViewController:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            tap.tag = listModel.videoID;
            [lanMuImageView addGestureRecognizer:tap];
            
            [lanMuView addSubview:mingChengLabel];
            [cell.contentView addSubview:lanMuView];
        }
    }
}

- (void)forwardingTargetAndBackForarding:(NSNotification *)noty
{
    if (moviePlayer.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward || moviePlayer.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward || moviePlayer.moviePlayer.playbackState ==MPMoviePlaybackStateInterrupted) {
        count = 10;
        NSLog(@"-------------快进或者快退了");
    } else {
        if ((moviePlayer.moviePlayer.currentPlaybackTime == moviePlayer.moviePlayer.duration) && (moviePlayer.moviePlayer.currentPlaybackTime != 0)) {
            [self requstTheAwardOfLookVideoInCompleteTime];
        }
    }
}

- (void)requstTheAwardOfLookVideoInCompleteTime
{
    if ([kkUserId isEqualToString:@""] || kkUserId == nil) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.viewControllerIndex = 4;
        [self.navigationController pushViewController:login animated:YES];
    }
    else {
        NSLog(@"-----++++++++-------%@",self.videoID);
        if ((count != 10) && ([record integerValue] != 1)) {
            [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoAddCoinUserId:kkUserCenterId andVideoId:self.videoID]];
            mainRequest.tag = 1000;
        }
    }
}

//播放视屏
- (void)playTheVideos:(UITapGestureRecognizer *)tap
{
    NSLog(@"-------------url-------%@",self.videoUrl);
    int netType = [GCUtil getNetworkTypeFromStatusBar];
    if (netType != 5 && netType != 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您正处于非Wifi网络 继续观看将产生流量费用" delegate:self cancelButtonTitle:@"取消播放" otherButtonTitles:@"继续观看", nil];
        [alert show];
    } else {
        moviePlayer = [[MPMoviePlayerViewController alloc] init];
        moviePlayer.moviePlayer.contentURL = [NSURL URLWithString:self.videoUrl];
        [moviePlayer.moviePlayer play];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"-----------%ld",(long)buttonIndex);
    
    if (buttonIndex == 0) {
        [alertView removeFromSuperview];
    } else {
        moviePlayer = [[MPMoviePlayerViewController alloc] init];
        moviePlayer.moviePlayer.contentURL = [NSURL URLWithString:self.videoUrl];
        [moviePlayer.moviePlayer play];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
    }
    
}

//移除引导页
- (void)removeYindaoYe
{
    [self.yinDaoYeView removeFromSuperview];
    self.coinView.hidden = NO;
}

//重新加载数据     数据加载成功 不要忘记移除self.noSingalView
- (void)reloadTheDatas:(UITapGestureRecognizer *)tap
{
    int netType = [GCUtil getNetworkTypeFromStatusBar];
    if ( netType == 0 ) {
        [self showStringMsg:@"网络连接失败" andYOffset:0];
    } else {
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
        mainRequest.tag = 100;
        [self showMsg:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playTheVideos:)];
        [self.videoImage addGestureRecognizer:tap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮点击事件
- (IBAction)buttonsClicked:(UIButton *)sender {
    //tag  11 简介     12 推荐   13点赞  14  分享   15 收藏
    if (sender.tag == 11) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:12];
        btn.selected = NO;
        sender.selected = YES;
        [self.tuiJianView removeFromSuperview];
//        int netType = [GCUtil getNetworkTypeFromStatusBar];
//        if ( netType == 0 ) {
//            [self showStringMsg:@"网络连接失败" andYOffset:0];
//        } else {
//            [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
//            mainRequest.tag = 100;
//        }
    } else if (sender.tag == 12) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:11];
        btn.selected = NO;
        sender.selected = YES;
        
        for (UIView *view in self.tuiJianScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        int netType = [GCUtil getNetworkTypeFromStatusBar];
        if ( netType != 0 ) {
            self.tuiJianArray = [@[] mutableCopy];
            self.haveLookedMovies = [@[] mutableCopy];
            self.tuiJianView.frame = CGRectMake(0, 0, self.tuiJianView.frame.size.width, self.tuiJianView.frame.size.height);
            [self.contentBgScrollView addSubview:self.tuiJianView];
            [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI recommendedVideoUserId:kkUserCenterId andSize:@"6" andpage:@"1" andPlayingVideoID:self.videoID]];
            mainRequest.tag = 150;
            if (isFirstIn == 0) {
                [self showMsg:nil];
            }
            isFirstIn++ ;
        } else {
            [self.contentBgScrollView addSubview:self.noSingalView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTheDatas:)];
            [self.noSingalView addGestureRecognizer:tap];
        }
        
    } else if (sender.tag == 13) {
        if ([kkUserId isEqualToString:@""] || kkUserId == nil) {
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            login.viewControllerIndex = 4;
            [self.navigationController pushViewController:login animated:YES];
        }
        else {
            sender.userInteractionEnabled = NO;
            if ([self.detailDic[@"code"] integerValue] == 0) {
                if (sender.selected) {
                    [self zanOrCollectCancleWithType:@"1"];
                } else {
                    [self zanOrCollectionWithType:@"1"];
                }
            } else {
                [self showStringMsg:@"获取不到此视频信息" andYOffset:0];
            }
        }
    } else if (sender.tag == 14) {
        self.shareContent = [NSString stringWithFormat:@"看视频拿积分哪家强？我正在看视频“%@”，快跟我一起看视频拿积分吧！ (来自于黑土App) http://ht.sinosns.cn/", self.titleLabel.text];
        [self callOutShareViewWithUseController:self andSharedUrl:@"http://ht.sinosns.cn/"];
    } else if (sender.tag ==15) {
        
        
        if ([kkUserId isEqualToString:@""] || kkUserId == nil) {
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            login.viewControllerIndex = 4;
            [self.navigationController pushViewController:login animated:YES];
        }
        else {
            self.collectionButton.userInteractionEnabled = NO;
            if ([self.detailDic[@"code"] integerValue] == 0) {
                if (sender.selected) {
                    [self zanOrCollectCancleWithType:@"2"];
                } else {
                    [self zanOrCollectionWithType:@"2"];
                }
            } else {
                [self showStringMsg:@"获取不到此视频信息" andYOffset:0];
            }
        }
    }
}

//点赞和收藏接口
- (void)zanOrCollectionWithType:(NSString *)type
{
    if ([kkUserId isEqual:@""] || !kkUserId) {
        //去登陆
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.viewControllerIndex = 4;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        int netType = [GCUtil getNetworkTypeFromStatusBar];
        if ( netType == 0 ) {
            [self showStringMsg:@"网络连接失败" andYOffset:0];
        } else {
            [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoPraiseAndCollectionUserId:kkUserCenterId andObjId:self.videoID andJoinType:type andObjType:@"1"]];
            mainRequest.tag = 110;
            zanOrCollect = YES;
        }
    }
}

//取消点赞和收藏接口
- (void)zanOrCollectCancleWithType:(NSString *)type
{
    if ([kkUserId isEqual:@""] || !kkUserId) {
        //去登陆
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.viewControllerIndex = 4;
        [self.navigationController pushViewController:login animated:YES];
    } else {
        int netType = [GCUtil getNetworkTypeFromStatusBar];
        if ( netType == 0 ) {
            [self showStringMsg:@"网络连接失败" andYOffset:0];
        } else {
            [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI ZanOrCollectionCancleWithUserID:kkUserCenterId andObjId:self.videoID andJoinType:type andObjectType:@"1"]];
            mainRequest.tag = 120;
            zanOrCollect = YES;
        }
    }
}

//返回按钮
- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)GCRequest:(GCRequest *)aRequest Finished:(NSString *)aString
{
    [self hide];
    NSLog(@"-------------%@",aString);
    NSDictionary *dic = [aString JSONValue];
    if (dic) {
        if (aRequest.tag == 100) {
            self.detailDic = dic;
            //获取简介信息等
            if ([dic[@"code"] integerValue] == 0) {
                [self.noSingalView removeFromSuperview];
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@", img_url, dic[@"video_img"]];
                [self.videoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage  imageNamed:@"defaultimgmall_banner_bg_img.png"]];
                self.titleLabel.text = dic[@"video_name"];
                self.videoUrl = dic[@"video_url"];
                self.priceLabel.text = dic[@"video_jifen"];
                self.yinDaoYeLaJiaoBiCount.text = dic[@"video_jifen"];
                NSString *intro = dic[@"intro"];
                NSData *introData = [GTMBase64 decodeString:intro];
                NSString *str = [[NSString alloc] initWithData:introData encoding:NSUTF8StringEncoding];
                [self.detailView loadHTMLString:str baseURL:nil];
                self.detailView.detectsPhoneNumbers = NO;
                self.detailView.dataDetectorTypes = UIDataDetectorTypeNone;
                self.zanLabel.text = dic[@"video_zan"];
                
                self.playerV.continueTime = 0;
                self.playerV.neverPlay = YES;
                self.playerV.videoUrl = dic[@"video_url"];
                self.canRotate = YES;
                self.noDataView.hidden = YES;
                self.playerV.beginImgView.hidden = NO;
                
                [self showModel];
                
                CGRect textSizeFrame = [GCUtil changeLabelFrame:self.priceLabel andSize:CGSizeMake(58, 21) andFontSize:[UIFont systemFontOfSize:13.0]];
                self.priceLabel.frame = CGRectMake(ORIGIN_X(self.priceLabel), ORIGIN_Y(self.priceLabel), textSizeFrame.size.width, 21);
                
                record = dic[@"record"];
                
                if ([record integerValue] == 1) {
                    self.weitherWatch.hidden = NO;
                } else {
                    self.weitherWatch.hidden = YES;
                }
                
                self.weitherWatch.frame = CGRectMake(ORIGIN_X(self.priceLabel) + CGRectGetWidth(self.priceLabel.frame) + 10, ORIGIN_Y(self.weitherWatch), 100, 21);
                if ([dic[@"zan"] integerValue] == 1) { // 赞
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_selected.png"];
                    self.zanButton.selected = YES;
                } else {
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_default.png"];
                    self.zanButton.selected = NO;
                }
                
                if ([dic[@"collect"] integerValue] == 1) { //收藏
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_selected.png"];
                    self.collectionButton.selected = YES;
                } else {
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_default.png"];
                    self.collectionButton.selected = NO;
                }
            } else {
                if (zanOrCollect) {
                    zanOrCollect = NO;
                } else {
                    [self showStringMsg:dic[@"message"] andYOffset:0];
                }
            }
        }
        
        //点赞、收藏
        if (aRequest.tag == 110) {
            self.zanButton.userInteractionEnabled = YES;
            self.collectionButton.userInteractionEnabled = YES;
            if ([dic[@"code"] integerValue] == 2) {
                if ([dic[@"tag"] integerValue] == 1) {
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_default.png"];
                    self.zanButton.selected = NO;
                } else if ( [dic[@"tag"] integerValue] == 2) {
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_default.png"];
                    self.collectionButton.selected = NO;
                }
            } else if ([dic[@"code"] integerValue] == 0) {
                if ([dic[@"tag"] integerValue] == 1) {
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_selected.png"];
                    self.zanButton.selected = YES;
                } else if ( [dic[@"tag"] integerValue] == 2) {
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_selected.png"];
                    self.collectionButton.selected = YES;
                }
                self.zanLabel.text = [NSString stringWithFormat:@"%d", [self.zanLabel.text intValue] + 1];
                //                [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
                //                mainRequest.tag = 100;
            }
            [self showMessageWithTag:dic[@"tag"] andMessageTitle:dic[@"message"]];
        }
        
        
        //取消点赞、收藏
        if (aRequest.tag == 120) {
            self.zanButton.userInteractionEnabled = YES;
            self.collectionButton.userInteractionEnabled = YES;
            if ([dic[@"code"] integerValue] == 0) {
                if ([dic[@"tag"] integerValue] == 1) {
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_default.png"];
                    self.zanButton.selected = NO;
                } else if ( [dic[@"tag"] integerValue] == 2) {
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_default.png"];
                    self.collectionButton.selected = NO;
                }
                [self showMessageWithTag:dic[@"tag"] andMessageTitle:@"取消成功"];
                
                //                [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
                //                mainRequest.tag = 100;
                self.zanLabel.text = [NSString stringWithFormat:@"%d", [self.zanLabel.text intValue] - 1];
            } else if ([dic[@"code"] integerValue] == 2) {
                if ([dic[@"tag"] integerValue] == 1) {
                    self.zanImageView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_approval_selected.png"];
                    self.zanButton.selected = YES;
                } else if ( [dic[@"tag"] integerValue] == 2) {
                    self.collectionView.image = [UIImage imageNamed:@"videodetails_bottommenu_btn_like_selected.png"];
                    self.collectionButton.selected = YES;
                }
            }
        }
        
        //完整看视屏加积分
        if (aRequest.tag == 1000) {
            if ([dic[@"code"] integerValue] == 0) {
                [self showStringMsg:[NSString stringWithFormat:@"获得%@积分",self.priceLabel.text] andYOffset:0];
                [GCUtil saveLajiaobijifenWithJifen:[NSString stringWithFormat:@"%d", [self.priceLabel.text intValue] + [[GCUtil getlajiaobiJinfen]  intValue]]];
                NSString *path = [[NSBundle mainBundle]pathForResource:@"获取积分声音" ofType:@"wav"];
                if (path.length > 0) {
                    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
                    [audioPlayer play];
                }
                
                [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:self.videoID]];
                mainRequest.tag = 100;
            } else {
                [self showStringMsg:dic[@"message"] andYOffset:0];
            }
        }
        
        //推荐视屏
        if (aRequest.tag == 150) {
            if ([dic[@"code"] integerValue] == 0 ) {
                NSArray *arr = dic[@"result"];
                for (int i = 0; i < arr.count; i ++) {
                    NSDictionary *detailDic = arr[i];
                    PRJ_VideoListModel *model = [PRJ_VideoListModel getVideoListModelWithDic:detailDic];
                    if ([model.videoRecord intValue] == 1) {
                        if ([model.videoID intValue] != [self.videoID intValue]) {
                            [self.haveLookedMovies addObject:model];
                        }
                    } else {
                        if ([model.videoID intValue] != [self.videoID intValue]) {
                            [self.tuiJianArray addObject:model];
                        }
                    }
                }
                
                [self.myTableView reloadData];
            } else if ([dic[@"code"] integerValue] == 1) {
                [self showStringMsg:@"没有更多视频了" andYOffset:0];
            } else {
                [self showStringMsg:dic[@"message"] andYOffset:0];
            }
        }
    } else {
        [self showStringMsg:@"网络连接失败" andYOffset:0];
    }
}


//获取播放视频的详情
- (void)playVideoIndetaiViewController:(UITapGestureRecognizer *)tap
{
    UIButton *tapButton = (UIButton *)[self.view viewWithTag:11];
    UIButton *btn = (UIButton *)[self.view viewWithTag:12];
    btn.selected = NO;
    tapButton.selected = YES;
    [self.tuiJianView removeFromSuperview];
    
    int netType = [GCUtil getNetworkTypeFromStatusBar];
    if ( netType == 0 ) {
        [self showStringMsg:@"网络连接失败" andYOffset:0];
        return;
    } else {
        [mainRequest requestHttpWithPost:CHONG_url withDict:[BXAPI videoMessageUserId:kkUserCenterId andVideoId:tap.tag]];
        mainRequest.tag = 100;
        [self showMsg:nil];
        self.videoID = tap.tag;
    }
}

- (void)GCRequest:(GCRequest *)aRequest Error:(NSString *)aError
{
    self.zanButton.userInteractionEnabled = YES;
    self.collectionButton.userInteractionEnabled = YES;
    [self hide];
    [self.contentBgScrollView addSubview:self.noSingalView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadTheDatas:)];
    [self.noSingalView addGestureRecognizer:tap];
    [self showStringMsg:@"网络连接失败" andYOffset:0];
}

//点赞、收藏提示框
- (void)showMessageWithTag:(NSString *)tag andMessageTitle:(NSString *)title
{
    self.view.userInteractionEnabled = NO;
    if (self.messageView) {
        [self.messageView removeFromSuperview];
    }
    self.messageView = [[UIView alloc] initWithFrame:CGRectMake(320 / 2 - 107 / 2, 10, 107, 96)];
    self.messageView.backgroundColor = [UIColor clearColor];
    [self.contentBgScrollView addSubview:self.messageView];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 107, 96)];
    back.image = [UIImage imageNamed:@"videodetails_pop_bg.png"];
    [self.messageView addSubview:back];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 18, 32, 32)];
    [self.messageView addSubview:imageView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 107, 44)];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:15.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = title;
    [self.messageView addSubview:messageLabel];
    
    if ([tag integerValue] == 1) {
        imageView.image = [UIImage imageNamed:@"videodetails_popl_ico_approva.png"];
    } else {
        imageView.image = [UIImage imageNamed:@"videodetails_popl_ico_like.png"];
        
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dimissTheAlertMessage) object:nil];
    [self performSelector:@selector(dimissTheAlertMessage) withObject:nil afterDelay:2.0];
    
}

//取消点赞提示框显示
- (void)dimissTheAlertMessage
{
    self.view.userInteractionEnabled = YES;
    [self.messageView removeFromSuperview];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait | toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft | toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;//只支持这一个方向(正常的方向)
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
