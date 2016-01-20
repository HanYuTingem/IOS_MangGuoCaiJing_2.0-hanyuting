//
//  ReportViewController.m
//  LaoYiLao
//
//  Created by sunsu on 16/1/14.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()
{
    UIView * _reportView;
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBarTitleWithString:@"神秘贺卡"];
    self.view.backgroundColor = [UIColor whiteColor];    
    [self addReportView];
    
}

-(void)addReportView{
    _reportView = [[UIView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
    [self.view addSubview:_reportView];
    
    CGFloat imageViewY = 60 ;
    CGFloat imageViewW = 54;
    CGFloat imageViewX = (kkViewWidth - imageViewW)/2;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewW)];
    imageView.image = [UIImage imageNamed:@"jubao_iconfont-gantanhao"];
    [_reportView addSubview:imageView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, kkViewWidth, 30)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"贺卡内容被举报，暂时无法查看";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_reportView addSubview:titleLabel];
    
    _reportView.hidden = YES;
}
//
//
//-(void)addPreView{
//    _preView = [[BaoheLweView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
//    _preView.hidden = YES;
//    [self.view addSubview:_preView];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
