//
//  ActivityRuleViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/11/2.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ActivityRuleViewController.h"
#import "ActivityRuleView.h"
#import "BarView.h"
@interface ActivityRuleViewController ()
{
    ActivityRuleView * _actRuleView;//活动规则view
}
@end

@implementation ActivityRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self changeBarTitleWithString:@"活动规则"];
    self.navigationController.navigationBarHidden = YES;
    self.customNavigation.shareButton.hidden = YES;
    self.customNavigation.rightButton.hidden = YES;
    
    [self initUI];
    
}

- (void) initUI{
    _actRuleView = [[ActivityRuleView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, kkViewHeight-NavgationBarHeight)];
    [self.view addSubview:_actRuleView];

}

#pragma navigationBarDelegate


-(void)helpBtnClicked{
}

-(void)shareBtnClicked{
    NSLog(@"分享");
}

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
