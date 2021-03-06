//
//  SINOActionDetailViewController.m
//  LANSING
//
//  Created by yll on 15/7/20.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "SINOActionDetailViewController.h"
#import "HTTPClientAPI.h"

@interface SINOActionDetailViewController ()<UIWebViewDelegate,shareDelegate>
{
    
    __weak IBOutlet UIImageView *rightImage;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UILabel *navLineLable;
}
@property (nonatomic, assign)BOOL isWeb;
@end

@implementation SINOActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.rightButton addSubview:shareButton];
    [self addRightBarButtonItemWithImageName:@"ActionImage1" andTargate:@selector(shareButtonClickAction:) andRightItemFrame:CGRectMake(ScreenWidth-22 - 10, 20 + 11, 22, 22) andButtonTitle:nil andTitleColor:nil];
//    [backView addSubview:navLineLable];
//    [backView addSubview:rightImage];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarWithState:1 andIsHideLeftBtn:NO andTitle:self.shareTitle];
//    titleButton.frame = CGRectMake((ScreenWidth - titleButton.width)/2, titleButton.top, titleButton.width, titleButton.height);
//    [titleButton setTitle:self.shareTitle forState:UIControlStateNormal];
//    [self. addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
//    self.actionDetailWebView
    [self.actionDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.actionDetailWebView.delegate = self;
    
    for(id subview in self.actionDetailWebView.subviews)
        if ([[subview class] isSubclassOfClass:[UIScrollView class]])
            ((UIScrollView *)subview).bounces = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.appDelegate.homeTabBarController hideTabBarAnimated:YES];
}

- (void)backButtonClick:(UIButton *)button
{
    if (self.isWeb) {
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
        [self.actionDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
//        [titleButton setTitle:self.shareTitle forState:UIControlStateNormal];
//        [self setNavigationBarWithState:1 andIsHideLeftBtn:NO andTitle:self.shareTitle];
        [self.titleLabel setText:self.shareTitle];
        self.isWeb = NO;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)shareButtonClickAction:(id)sender {
    //分享根据自己的项目填写对应的参数  为nil 的都需要自己添加对应的  1：也需要自行添加
//    [self shareTitle:self.shareTitle withUrl:nil withContent:self.shareContent withImageName:nil withShareType:1 ImgStr:nil domainName:nil];
//    self.shareContent = @"http://lw.sinosns.cn/index.php/welcome?yqm=000131";//self.shareTitle;
//    [self callOutShareViewWithUseController:self andSharedUrl:@"http://lw.sinosns.cn/index.php/welcome?yqm=000131"];
//    [self shareTitle:self.shareTitle withUrl:@"http://lw.sinosns.cn/index.php/welcome?yqm=000131" withContent:self.shareContent withImageName:@"http://lw.sinosns.cn/attachments/2015/01/14213706513fd2c7ce58844f91.png" withShareType:8 ImgStr:@"http://lw.sinosns.cn/attachments/2015/01/14213706513fd2c7ce58844f91.png" domainName:@"http://lw.sinosns.cn"];
    
    self.shareContent = [NSString stringWithFormat:@"%@  快戳活动地址,参与吧!:%@  客户端地址:http://mgcj.sinosns.cn/",self.shareTitle,self.urlStr];
    NSURL *imageUrl = [NSURL URLWithString:self.imageUrl];
    UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    self.shareImageName = shareImage;
    self.shareDelegate = self;
    [self callOutShareViewWithUseController:self andSharedUrl:[NSString stringWithFormat:@"%@",self.shareUrl]];
    //[self callOutShareViewWithUseController:self andSharedUrl:[NSString stringWithFormat:@"%@",@"http://mgcj.sinosns.cn"]];
}

- (void)shareSuccess
{

#pragma mark==============********//userId: 用户id，对应各自项目中存的,自行替换
    NSString *userId;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:usernameMessageJava];
    userId = [dic objectForKey:@"id"];
    
    mainRequest.tag = 100;
    [mainRequest requestHttpWithPost:CHONG_url withDict:[HTTPClientAPI recordsShareNumberToActionDetailFormUserId:userId activityId:self.actionId]];
}
//-(void)GCRequest:(GCRequest *)aRequest Finished:(NSString *)aString
//{
//  
//}
//
//-(void)GCRequest:(GCRequest *)aRequest Error:(NSString *)aError
//{
//    
//}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if ([self itisIncludeTheString:request.URL]) {
            if ([self.type isEqualToString:@"2"]) {
//                [self setNavigationBarWithState:1 andIsHideLeftBtn:NO andTitle:@"报名"];
                [self.titleLabel setText:@"报名"];
            }else if ([self.type isEqualToString:@"3"]){
//                [titleButton setTitle:@"问卷" forState:UIControlStateNormal];
//                [self setNavigationBarWithState:1 andIsHideLeftBtn:NO andTitle:@"问卷"];
                [self.titleLabel setText:@"问卷"];
            }
            self.isWeb = YES;
        }
        
//        return NO;
    }
    return YES;
}

//判断roadTitleLab.text 是否含有qingjoin
- (BOOL) itisIncludeTheString:(NSURL *)urlStr{
    if([[urlStr absoluteString] rangeOfString:@"http://activity.sinosns.cn/index.php/activity/activeForm"].location !=NSNotFound)//_roaldSearchText
    {
        return YES;
    }
    else
    {
        return NO;
    }

}


@end
