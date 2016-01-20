//
//  GDHCouponInfoWebViewController.m
//  GongYong
//
//  Created by GDH on 16/1/6.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "GDHCouponInfoWebViewController.h"

@interface GDHCouponInfoWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation GDHCouponInfoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (([self.webUrl rangeOfString:@"https://"].location == NSNotFound) && ([self.webUrl rangeOfString:@"http://"].location == NSNotFound)) {
        self.webUrl = [NSString stringWithFormat:@"https://%@",self.webUrl];
    } else if ([self.webUrl rangeOfString:@"http://"].location != NSNotFound) {
        self.webUrl = [self.webUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    
    NSLog(@"%@",self.webUrl);
    
    [self makeWebView];
    self.mallTitleLabel.text = [NSString stringWithFormat:@"%@",self.titleName];
    // Do any additional setup after loading the view from its nib.
}


-(void)makeWebView{
    
    webView = [[UIWebView  alloc] initWithFrame:CGRectMake(0, 65, kkViewWidth, kkViewHeight - 65)];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    NSURL  *url = [NSURL URLWithString:self.webUrl];

    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:req];

}

//加载开始
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"加载开始的时候的方法调用");
    [self chrysanthemumOpen];
}
//加载完成
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成的时候电脑方法调用");
    [self chrysanthemumClosed];
}
//加载出错
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载出错的时候的调用");
    [self chrysanthemumClosed];
//    [self showMsg:ShowMessage];
}


@end
