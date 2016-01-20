//
//  HeKaLodeController.m
//  LaoYiLao
//
//  Created by liujinhe on 16/1/14.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "HeKaLodeController.h"
#import "BaoheLweView.h"
@interface HeKaLodeController ()
@property (nonatomic,strong) BaoheLweView *heWest;//
@end

@implementation HeKaLodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeBarTitleWithString:@"贺卡"];
    self.customNavigation.shareButton.hidden = YES;
    self.customNavigation.rightButton.hidden = YES;
    self.customNavigation.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ljh_baoheka_bg.png"]];
 
    [self makeUI];
}


- (void)makeUI{
    _heWest = [[BaoheLweView alloc]initWithFrame:CGRectMake(0, 64, kkViewWidth, kkViewHeight-64)];
    _heWest.model = self.model;
//    _heWest.backgroundColor = [UIColor blueColor];
    __block HeKaLodeController *seDe = self;
    _heWest.buttonClicBook = ^void(UIButton*button){
        [seDe buttonClicked];
    };
    [self.view addSubview:_heWest];
}


- (void)buttonClicked{
    ZHLog(@"发贺卡");
    

}
@end
