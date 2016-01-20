//
//  BaoHeKaViewController.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "BaoHeKaViewController.h"
#import "YLLTextPutView.h"
#import "ActivityRuleViewController.h"
#import "LJHTanChuTiView.h"
#import "LJHTanChuViewAnimation.h"
#import <AWSS3/AWSS3.h>
#import "Constants.h"
#import "NSString+MD5.h"
#define DingBu_HigrtY      94
#define DingBu_WithtX      10
#define DingBu_Witht_li    kkViewWidth-DingBu_WithtX*2
#define DingBu_Higrt_li    DingBu_Witht_li
#define AWSURL             @"http://s3.bj.xs3cnc.com"
@interface BaoHeKaViewController ()<YLLTextPutViewDelegate,LJHTanChuNeiViewDelegate,AmazonServiceRequestDelegate>
@property (nonatomic,strong)BaoHeKaBaseView *baohekaView;//基础View
@property (nonatomic,strong)NSString *prerDwert;//记录祝福语
@property (nonatomic,strong)NSString *dumplinguserputmoneyid;//小锅ID
@property (nonatomic,strong)NSString *urlStrForpic;//记录url
@property (nonatomic, strong) S3TransferManager *tm;
@property (nonatomic, strong) S3TransferOperation *uploadBigFileOperation;
@property (nonatomic, strong) S3TransferOperation *uploadPickerOperation;

@end

@implementation BaoHeKaViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    [self changeBarTitleWithString:@"包贺卡"];
    self.customNavigation.shareButton.hidden = NO;
    self.customNavigation.rightButton.hidden = NO;
    self.customNavigation.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ljh_baoheka_bg.png"]];
    [self makeUI];
    [self startViewUpDaot];
}
- (void)startViewUpDaot{
    if (self.tm ==nil) {
        AmazonS3Client *s3 = [[AmazonS3Client alloc]initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        s3.endpoint = AWSURL;
        self.tm = [S3TransferManager new];
        self.tm.s3 = s3;
        self.tm.delegate = self;
    }
}
-(void)backBtnClicked{
    LJHTanChuTiView* lookeVc = [LJHTanChuTiView sharedManager];
    [LJHTanChuViewAnimation showView:lookeVc.teeVV overlayView:lookeVc.teeVV];
    [lookeVc turnDefoutViewWithTyp:2];
    lookeVc.teeVV.delegate = self;
    [self.view addSubview:lookeVc];
}
/**
 *  弹出框代理方法
 */
- (void)buFaSong{
    //不发送
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)faSongEwss{
    [_baohekaView.textView whenClickBackButton];
    //发送
    [self clickSendDumplingByStr:_baohekaView.textView.nowBlessing];
}
-(void)helpBtnClicked{
    NSLog(@"帮助");
    ActivityRuleViewController * ar = [[ActivityRuleViewController alloc]init];
    [self.navigationController pushViewController:ar animated:YES];

}
-(void)shareBtnClicked:(UIButton *)btn{
   NSLog(@"分享");
    
}
//配置UI
- (void)makeUI{
    _baohekaView = [BaoHeKaBaseView shareMangerWithVc:self];
    _baohekaView.textView.delegate = self;
    [self.view addSubview:_baohekaView];
}
#pragma mark 发饺子代理
-(void)clickSendDumplingByStr:(NSString *)str{
    ZHLog(@"发饺子");
    NSLog(@"%@",str);
    _prerDwert = str;
    [self upDataPicTolier];
}
- (void)upDataPicTolier{
//方法一
   UIImage *imges = _baohekaView.iWmageView.image;
    if ([imges isEqual:[UIImage imageNamed:@"ljh_baoheka_bgdefault.png"]]) {
       //如果优化上传空间时,需要在此添加URL固定
        ZHLog(@"一致");
        _urlStrForpic = [self donTonGewt];
        [self getMangerTestUrl:[NSString stringWithFormat:@"%ld",(long)_baoHeKaLaitap]];
    }else{
        ZHLog(@"不一致");
        _urlStrForpic = [self kaeoeLuJineStr];
        NSData *imageData = UIImagePNGRepresentation(imges);
        S3PutObjectRequest *putObjectRequest = [S3PutObjectRequest new];
        putObjectRequest.data = imageData;
        putObjectRequest.bucket = [Constants transferManagerBucket];
        putObjectRequest.key = _urlStrForpic;
        putObjectRequest.contentType = @"text/plain";
        putObjectRequest.cannedACL = [S3CannedACL publicRead]; //设置文件的 ACL 权限
        [self showHudInView:self.view hint:nil];
        self.uploadBigFileOperation = [self.tm upload:putObjectRequest];
    }
   // 方法二
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"lingquchenggong_img"]);
//    S3PutObjectRequest *putObjectRequest = [S3PutObjectRequest new];
//    putObjectRequest.cannedACL = [S3CannedACL publicRead];
//    //putObjectRequest.metadata = [NSMutableDictionary dictionary];
//   _uploadPickerOperation = [self.tm uploadData:imageData bucket:[Constants transferManagerBucket] key:[NSString stringWithFormat:@"%@",kKeyForBigFile]];

}

#pragma mark 包贺卡网络请求
- (void)getMangerTestUrl:(NSString*)likeEr{
     [self showHudInView:self.view hint:nil];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool getNewCardDumplingWithPic:_urlStrForpic cardWish:_prerDwert sendType:likeEr cardUrl:LYL_SaveCardDumpling ] success:^(id json) {
         NSString *sweTreCode = [json objectForKey:@"code"];
        if ([sweTreCode isEqualToString:@"100"]) {
            [LYLAFNetWorking getWithBaseURL:[LYLHttpTool getNewCardDumplingWithPic:_urlStrForpic cardWish:_prerDwert sendType:likeEr cardUrl:LYL_NewCardDumpling] success:^(id json) {
            NSString *strTreCode = [json objectForKey:@"code"];
            if([strTreCode isEqualToString:@"100"]){
                NSString *dumplinguserputmoneyid = [[json objectForKey:@"resultList"] objectForKey:@"dumplingUserPutcardId"];
                NSLog(@"%@",dumplinguserputmoneyid);
                _dumplinguserputmoneyid = dumplinguserputmoneyid;
                [self hetErUrelpost:_dumplinguserputmoneyid];
                [self hideHud];
            }else{
                [self showHint:@"太拥挤了,请稍等" yOffset:-100];
                [self hideHud];
                
            }
            
            ZHLog(@"%@",json);
        } failure:^(NSError *error) {
            [self hideHud];
            
        }];
        
        }else{
        
        [self hideHud];
        }
            
        } failure:^(NSError *error) {
        
         [self hideHud];
        
    }];
    
 

}
/**跳转页面*/
- (void)hetErUrelpost:(NSString*)tre{
    BaoJiaoSuccectController *baojiaoWh = [[BaoJiaoSuccectController alloc ] init];
    if (_baoHeKaLaitap==0) {
            //发给朋友
        baojiaoWh.tempDe = 3;
    }else{
            //发给有缘人
        baojiaoWh.tempDe = 2;
    }
    baojiaoWh.dumplinguserputmoneyid = tre;
    [self.navigationController pushViewController:baojiaoWh animated:YES];
}


/**
 *  判断是否遮挡键盘
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self registerForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
     if ([_baohekaView.textView.textV isFirstResponder] ) {
    
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    NSLog(@"%f-",kbSize.height);
    _baohekaView.contentInset = contentInsets;
    
    _baohekaView.scrollIndicatorInsets = contentInsets;
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your application might not need or want this behavior.
    
    CGRect aRect =  _baohekaView.frame;
    aRect.size.height -= kbSize.height;
//    NSInteger trGao = (kkViewHeight -kbSize.height) - (_baohekaView.textView.textV.frame.origin.y+64 +_baohekaView.textView.textV.frame.size.height+36);
//    NSLog(@"%f-----+%d",kbSize.height,trGao);
  //  if ([_baohekaView.textView.textV isFirstResponder]) {
        
        CGPoint scrollPoint = CGPointMake(0.0,kbSize.height);//
        //   NSLog(@"%f",_baseShuChuView.bumView.frame.size.height-kbSize.height);
        [_baohekaView setContentOffset:scrollPoint animated:YES];
        
   // }
     }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _baohekaView.contentInset = contentInsets;
    
    _baohekaView.scrollIndicatorInsets = contentInsets;
    
    
}
#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long) bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
   
    [self getMangerTestUrl:[NSString stringWithFormat:@"%ld",(long)_baoHeKaLaitap]];
    
    [self hideHud];
    ZHLog(@"http://sinoglobal.cdn.bj.xs3cnc.com/%@",_urlStrForpic);
    
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    [self hideHud];
     [self showHint:@"太拥挤了,请稍等" yOffset:-100];
    NSLog(@"didFailWithError called: %@", error);
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    [self hideHud];
     [self showHint:@"太拥挤了,请稍等" yOffset:-100];
    NSLog(@"didFailWithServiceException called: %@", exception);
}
//获取当前服务器时间戳
- (NSString*)NowTime{
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
        NSRange range = [timeString rangeOfString:@"."];
        NSLog(@"%@-......",timeString);
        timeString = [timeString substringToIndex:range.location];
        NSLog(@"%@-......",timeString);
        return timeString;
}
//上传路径
- (NSString*)kaeoeLuJineStr{
    NSString *str1 = [self NowTime];
    NSString *str2 = [str1 md5Encrypt];
    NSString *str3 = [str2 substringFromIndex:str2.length-4];
    NSString *str4 = [LYLUserId md5Encrypt];
    NSString *str5 = [str4 substringFromIndex:str4.length-4];
    NSString *str6 = [NSString stringWithFormat:@"%@_%@",str1,LYLUserId];
    NSString *str7 = [NSString stringWithFormat:@"%@/%@/%@/%@.png",kKeyForBigFile,str3,str5,str6];
    return str7;
}
//固定路径
- (NSString*)donTonGewt{
    NSString *str1 = [NSString stringWithFormat:@"%@/LJHYear/RetrG/578441yeargert89.png",kKeyForSmallFile];
    return str1;
}
@end
