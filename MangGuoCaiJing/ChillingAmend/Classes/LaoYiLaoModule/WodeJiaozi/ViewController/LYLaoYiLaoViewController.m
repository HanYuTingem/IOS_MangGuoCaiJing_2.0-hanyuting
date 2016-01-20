//
//  LYLaoYiLaoViewController.m
//  LaoYiLao
//
//  Created by Li on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LYLaoYiLaoViewController.h"
#import "LYMyDumplingsReceiveView.h"
#import "mineWalletViewController.h"
#import "NewMyDumpView.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MyDumplingViewController.h"
#import "WXApi.h"

@interface LYLaoYiLaoViewController ()<UMSocialUIDelegate> {
    NewMyDumpView *_newMyDumpView;
    
    BOOL _isShare;// 是否分享
}

/** 页面整体的scrollView */
@property (nonatomic, strong) UIScrollView *mainScroll;
/** 提示文字 */
@property (nonatomic, strong) UILabel *tipLabel;
/** 上半部分背景图片 */
@property (nonatomic, strong) UIImageView *backImageView;
/** 领取数据左侧红色的条 */
@property (nonatomic, strong) UIImageView *leftReceiveImageView;
/** 领取数据右侧红色的条 */
@property (nonatomic, strong) UIImageView *rightReceiveImageView;
/** 饺子领取的数据 */
@property (nonatomic, strong) NSArray *receiveData;

@end

@implementation LYLaoYiLaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToMyDumpling) name:@"shareCallBack" object:nil];
    _isShare = NO;
#warning 测试数据
//    if (!_dumplingStates) {
//        _dumplingStates = @"1";
//    }
    
    [self basicSettings];
    [self configureDetailedUI];
    [self getReceiveData];
}

- (void)popToMyDumpling{
    if(_isShare){
        for (UIViewController *myDumplingVc in self.navigationController.viewControllers){
            if([myDumplingVc isKindOfClass:[MyDumplingViewController class]]){
                [self.navigationController popToViewController:myDumplingVc animated:YES];
            }
        }
    }
}

#pragma mark - 页面基本设置
- (void)basicSettings {
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigation.backgroundColor = RGBACOLOR(192, 21, 31, 1);
    [self changeBarTitleWithString:@"捞一捞"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kkViewWidth, kkViewHeight-64)];
    _mainScroll.backgroundColor = [UIColor colorWithRed:252/255.0 green:236/255.0 blue:210/255.0 alpha:1.0];
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.bounces = NO;
    [self.view addSubview:_mainScroll];
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, kkViewWidth*292/320)];
    _backImageView.image = [UIImage imageNamed:@"laojiaozi-laodao-01"];
    _backImageView.userInteractionEnabled = YES;
    [_mainScroll addSubview:_backImageView];
    
    UILabel *userPhonelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 161*kkViewWidth/320, kkViewWidth-140, 13)];
    userPhonelabel.font = [UIFont systemFontOfSize:14];
    userPhonelabel.textColor = [UIColor whiteColor];
    userPhonelabel.text = [NSString stringWithFormat:@"%@",LYLPhone];
    userPhonelabel.textAlignment = NSTextAlignmentCenter;
    [_backImageView addSubview:userPhonelabel];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_backImageView.frame)-73*kkViewWidth/320-15, kkViewWidth-60, 15)];
    _tipLabel.font = [UIFont boldSystemFontOfSize:14];
    _tipLabel.textColor = [UIColor colorWithRed:235/255.0 green:219/255.0 blue:0/255.0 alpha:1.0];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_backImageView addSubview:_tipLabel];
    
    UIImageView *receiveHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_backImageView.frame)+14, kkViewWidth, 27)];
    receiveHeadImageView.image = [UIImage imageNamed:@"laojiaozi-laodao-xiabiankuang-tou"];
    [_mainScroll addSubview:receiveHeadImageView];
    
    UILabel *receiveHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kkViewWidth, 27)];
    receiveHeadLabel.center = receiveHeadImageView.center;
    receiveHeadLabel.font = [UIFont systemFontOfSize:14];
    receiveHeadLabel.textColor = [UIColor whiteColor];
    receiveHeadLabel.textAlignment = NSTextAlignmentCenter;
    receiveHeadLabel.text = @"看看都有谁捞到了我的饺子";
    [_mainScroll addSubview:receiveHeadLabel];
    
    _leftReceiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(receiveHeadImageView.frame), 7, kkViewHeight-CGRectGetMaxY(receiveHeadImageView.frame))];
    _leftReceiveImageView.image = [UIImage imageNamed:@"laojiaozi-laodao-xiabiankuang-zuobian"];
    [_mainScroll addSubview:_leftReceiveImageView];
    
    _rightReceiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kkViewWidth-7, CGRectGetMaxY(receiveHeadImageView.frame), 7, kkViewHeight-CGRectGetMaxY(receiveHeadImageView.frame))];
    _rightReceiveImageView.image = [UIImage imageNamed:@"laojiaozi-laodao-xiabiankuang-youbian"];
    [_mainScroll addSubview:_rightReceiveImageView];
}

-(void)showMyDumpUI{
    CGRect myDumpViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _newMyDumpView = [[NewMyDumpView alloc]initWithFrame:myDumpViewFrame];
    [self.view addSubview:_newMyDumpView];
}

#pragma mark - 根据饺子状态不同设置详细的界面
- (void)configureDetailedUI {
    if ([_dumplingStates isEqualToString:@"1"] || [_dumplingStates isEqualToString:@"4"]) {
        if ([_dumplingStates isEqualToString:@"1"]) {
            _tipLabel.text = @"现金未领完，继续发饺子";
        } else {
            _tipLabel.text = @"现金未发送，继续发饺子";
        }
        
        CGFloat gapWidth = (kkViewWidth - 100*2) / 120 * 16;
        CGFloat startY = (kkViewWidth - 100*2) / 120 * 52;
        NSArray *buttonTitles = @[@"微信好友", @"QQ好友"];
        for (int i=0; i<buttonTitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(startY+(gapWidth+100)*i, CGRectGetMaxY(_backImageView.frame)-24*kkViewWidth/320-32, 100, 32);
            
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:254/255.0 green:194/255.0 blue:48/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_moren"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_dianji"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(shareToFriends:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(changeButtonFont:) forControlEvents:UIControlEventTouchDown];
            button.tag = 500 + i;
            
            [_backImageView addSubview:button];
        }
    } else if ([_dumplingStates isEqualToString:@"2"]) {
        _tipLabel.text = @"简直神速，饺子被吃光";
        
        UIButton *makeDumpAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        makeDumpAgain.frame = CGRectMake((kkViewWidth-100)/2, CGRectGetMaxY(_backImageView.frame)-24*kkViewWidth/320-32, 100, 32);
        [makeDumpAgain setTitle:@"再去包一个" forState:UIControlStateNormal];
        [makeDumpAgain setTitleColor:[UIColor colorWithRed:254/255.0 green:194/255.0 blue:48/255.0 alpha:1.0] forState:UIControlStateNormal];
        [makeDumpAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        makeDumpAgain.titleLabel.font = [UIFont systemFontOfSize:14];
        [makeDumpAgain setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_moren"] forState:UIControlStateNormal];
        [makeDumpAgain setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_dianji"] forState:UIControlStateHighlighted];
        [makeDumpAgain addTarget:self action:@selector(makeDumpAgain:) forControlEvents:UIControlEventTouchUpInside];
        [makeDumpAgain addTarget:self action:@selector(changeButtonFont:) forControlEvents:UIControlEventTouchDown];
        
        [_backImageView addSubview:makeDumpAgain];
    } else if ([_dumplingStates isEqualToString:@"3"]) {
        _tipLabel.text = @"现金未领完，已退回到我的钱包";
        
        CGFloat gapWidth = (kkViewWidth - 100*2) / 120 * 16;
        CGFloat startY = (kkViewWidth - 100*2) / 120 * 52;
        NSArray *buttonTitles = @[@"再去包一个", @"我的钱包"];
        for (int i=0; i<buttonTitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(startY+(gapWidth+100)*i, CGRectGetMaxY(_backImageView.frame)-24*kkViewWidth/320-32, 100, 32);
            
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:254/255.0 green:194/255.0 blue:48/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_moren"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"laojiaozi_laodao_dianji"] forState:UIControlStateHighlighted];
            if (i == 0) {
                [button addTarget:self action:@selector(makeDumpAgain:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [button addTarget:self action:@selector(myWallet:) forControlEvents:UIControlEventTouchUpInside];
            }
            [button addTarget:self action:@selector(changeButtonFont:) forControlEvents:UIControlEventTouchDown];
            
            [_backImageView addSubview:button];
        }
    }
}

- (void)shareToFriends:(UIButton *)button {

    if([MyObjectForKey(ShareTypeKey) isEqualToString:ShareTypeWithMakeMoney]){
        //        sharePlatformArray   = @[UMShareToWechatSession,UMShareToQQ];
        if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            [LYLTools showInfoAlert:@"当前设备没有任何可分享应用，请安装应用后再分享"];
            return;
        }
    }
    
    _isShare = NO;
//    NSString * idStr = @"http://dzw.sinosns.cn";//= @"http://www.baidu.com/";

    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self showHudInView:self.view hint:@""];
    [LYLAFNetWorking postWithBaseURL:[LYLHttpTool getShareInfoWithTempid:@"10004" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""] success:^(id json) {
        [self hideHud];
        int  code = [[json objectForKey:@"code"]intValue];
        ZHLog(@"分享返回的接口%@",json);
        switch (code) {
            case 100://成功
            {
                NSDictionary * resultListDict = [(NSDictionary *)json objectForKey:@"resultList"];              
                //分享的url
                NSString * jsonUrl = [resultListDict objectForKey:@"url"];
                jsonUrl = [NSString stringWithFormat:@"%@/?name=%@&productCode=%@&pannikin_id=%@",jsonUrl,LYLPhone,ProductCode,_dumplingUserPutmoneytid];
                //分享图片
                NSString * picUrl = [resultListDict objectForKey:@"picurl"];
                //分享标题
                NSString * title = [resultListDict objectForKey:@"title"]; //饺子捞起来~我包！众明星携手为你包饺子，捞一捞，2亿现金等你拿！~;//待产品确定分享内容
                //分享内容
                NSString * content = [resultListDict objectForKey:@"content"];//分享内容
                if ([content isEqualToString:@""]) {
                    content = @"我在过年秀捞一捞活动捞到50个饺子，点我你也有钱拿。";
                }
                
                UIImage *shareImage = nil;
                if ([picUrl isEqualToString:@""]) {
                    shareImage = [UIImage imageNamed:@"9_default_avatar"];
                } else {
                    shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]]];
                }
                

//                [UMSocialData defaultData].extConfig.qqData.shareImage = shareImage;
//                [UMSocialData defaultData].extConfig.sinaData.shareImage = shareImage;
//                [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = shareImage;

//                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:idStr];
//                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:idStr];
                [UMSocialQQHandler setQQWithAppId:QQ_APPID appKey:QQ_APPKEY url:jsonUrl];
                [UMSocialWechatHandler setWXAppId:WX_APPID appSecret:WX_AppSecret url:jsonUrl];
                [UMSocialSinaHandler openSSOWithRedirectURL:OpenSSOWithRedirectURL];
                
                //标记分享
                _isShare = YES;
                switch (button.tag - 500) {
                    case 0: {
                        NSLog(@"分享给微信好友");
                        {
//                            [UMSocialData defaultData].extConfig.wechatSessionData.url = jsonUrl;
//                            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;

                            [[UMSocialControllerService defaultControllerService] setShareText:content shareImage: shareImage socialUIDelegate:self];        //设置分享内容和回调对象
                            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                            
                            
                        }
                        break;
                    }
                    case 1: {
                        NSLog(@"分享给QQ好友");
                        {
                            NSLog(@"QQjsonUrl==%@",jsonUrl);
//                            [[UMSocialData defaultData].extConfig.qqData setUrl:jsonUrl];
                            [UMSocialData defaultData].extConfig.qqData.title = title;
                            
                            [[UMSocialControllerService defaultControllerService] setShareText:content shareImage: shareImage socialUIDelegate:self];
                            NSLog(@"shareImage == %@",shareImage);
                            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                            ZHLog(@"分享返回的接口jsonUrl == %@",jsonUrl);

                        }
                        break;
                    }
                        

//                    case 2: {
//                        NSLog(@"分享给微博好友");{
//                            [[UMSocialControllerService defaultControllerService] setShareText:newTitle shareImage: shareImage socialUIDelegate:self];
//                            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//                        }
//                        break;
//                    }
                }

//                [viewController baseShareText: withUrl:proUrl withContent:content withImageName:picUrl ImgStr:picUrl domainName:@"" withqqTitle:title withqqZTitle:title withweCTitle:title withweChtTitle:title withsinaTitle:newTitle];
                
            }
                break;
            case 102:
            {
                [LYLTools showInfoAlert:json[@"message"]];
            }
                break;
                
                
            default:
                break;
        }
        
        
//

        
    } failure:^(NSError *error) {
        [self hideHud];
        [LYLTools showInfoAlert:@"网络状态不佳"];
    }];

    
    
}

- (void)makeDumpAgain:(UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"再去包一个");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popLYLVC" object:@"1"];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[LaoYiLaoViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)myWallet:(UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"我的钱包");
    mineWalletViewController *mineVc = [[mineWalletViewController alloc]init];
    [self.navigationController pushViewController:mineVc animated:YES];
}

- (void)changeButtonFont:(UIButton *)button {
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

#pragma mark - 获取饺子领取的数据
- (void)getReceiveData {
    [self showHudInView:self.view hint:@"正在加载"];
//    @"5ca478fff612433fa138bbc6ef87bd2a"
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool makeDumplingDetailWithDumplingUserPutmoneytid:_dumplingUserPutmoneytid] success:^(id json) {
        [self hideHud];
        ZHLog(@"json = %@",json);
        if([json[@"code"] isEqualToString:@"100"]){
            if([json[@"resultList" ] isKindOfClass:[NSArray class]]){
                _receiveData = json[@"resultList"];
                [self refreshUI];
            }
//            if([json[@"resultList"] isEqual:@""]){
//                //            [LYLTools ]
//            }else{
//                           }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        ZHLog(@"error = %@",error);
    }];
    
    
    
//    _receiveData = @[@{@"phone": @"13922945582", @"prizeAmount": @"51.88", @"laoquDate": @"2015-10-08 15:22:40", @"Ok": @"手气最佳"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40", @"Ok": @"手气最佳"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"555555555.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"55.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"522.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"32325.88", @"getDate": @"2015-10-08 15:22:40"}, @{@"phone": @"13922945582", @"moneyNum": @"5.88", @"getDate": @"2015-10-08 15:22:40", @"Ok": @"手气最佳"}];
//    [self refreshUI];
}

#pragma mark - 根据数据更新视图
- (void)refreshUI {
    //显示数据的数量 最多十条
    NSInteger showDataNumbers = _receiveData.count;//>10?10:_receiveData.count;
    
    CGFloat locationY = _leftReceiveImageView.frame.origin.y + 1;
    for (int i=0; i<showDataNumbers; i++) {
        LYMyDumplingsReceiveView *receiveView = [[LYMyDumplingsReceiveView alloc] initWithFrame:CGRectMake(7, locationY, kkViewWidth-14, 44)];
        NSString *receiveInfo = [NSString stringWithFormat:@"%@捞到了饺子，已领取%@元！", _receiveData[i][@"phone"], _receiveData[i][@"prizeAmount"]];
        receiveView.infoLabel.text = receiveInfo;
        
        NSNumber *timeNum = _receiveData[i][@"laoquDate"];
        NSString *timeStr = [NSString stringWithFormat:@"%lld", [timeNum longLongValue] / 1000];
        receiveView.timeLabel.text = [self getTimeToShowWithTimestamp:timeStr];
        
        if (_receiveData[i][@"ok"] && ![_receiveData[i][@"ok"] isKindOfClass:[NSNull class]]) {
            if ([_receiveData[i][@"ok"] isEqualToString:@"最佳手气"]) {
                UIImageView *bestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(receiveView.frame.size.width-43, -1, 43, 40)];
                bestImageView.image = [UIImage imageNamed:@"laojiaozi-laodao-sqzj"];
                [receiveView addSubview:bestImageView];
                if (i) {
                    bestImageView.frame = CGRectMake(receiveView.frame.size.width-43, 6, 43, 40);
                    
                    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(7, locationY+6, kkViewWidth-14, 40)];
                    coverView.backgroundColor = [UIColor colorWithRed:254/255.0 green:194/255.0 blue:48/255.0 alpha:0.2];
                    [_mainScroll addSubview:coverView];
                }
            }
        }
        
        [_mainScroll addSubview:receiveView];
        
        locationY = CGRectGetMaxY(receiveView.frame);
    }
    
    if (locationY+12 > kkViewHeight - 64) {
        CGRect leftFrame = _leftReceiveImageView.frame;
        leftFrame.size.height = locationY + 12 - leftFrame.origin.y;
        _leftReceiveImageView.frame = leftFrame;
        
        CGRect rightFrame = _rightReceiveImageView.frame;
        rightFrame.size.height = locationY + 12 - rightFrame.origin.y;
        _rightReceiveImageView.frame = rightFrame;
    }
    
    CGFloat contentSizeHeight = locationY+12>kkViewHeight-64?locationY+12:kkViewHeight-64;
    _mainScroll.contentSize = CGSizeMake(kkViewWidth, contentSizeHeight);
}

- (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval: interval];
    
    NSString *publishString = [formatter stringFromDate:publishDate];
    
    return publishString;
}


-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    if (response.responseCode == UMSResponseCodeSuccess) {
        [LYLAFNetWorking postWithBaseURL:[LYLHttpTool changeDumplingStateWithPannikinId:_dumplingUserPutmoneytid] success:^(id json) {
            ZHLog(@"改变状态%@",json);
        } failure:^(NSError *error) {
            ZHLog(@"改变状态失败%@",error);
        }];
    }
    [UMSocialData defaultData].extConfig.qqData.shareImage = nil;
    [UMSocialData defaultData].extConfig.qqData.shareText = nil;
    [UMSocialData defaultData].extConfig.qqData.title = nil;
    [UMSocialData defaultData].extConfig.qqData.url = nil;
}

@end
