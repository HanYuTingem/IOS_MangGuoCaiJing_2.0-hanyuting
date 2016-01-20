//
//  LaoMyCounponListViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

/*
 此页 废弃
 */

#import "LaoMyCounponListViewController.h"
#import "NewNoDumpView.h"
#import "SSLMyCounponTableView.h"

@interface LaoMyCounponListViewController ()
{
    NewNoDumpView  * _noDumpView;
    SSLMyCounponTableView  * _myCounponTableView;
    
    
}

@end

@implementation LaoMyCounponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(235, 235, 241, 1);//[UIColor whiteColor];
    [self changeBarTitleWithString:@"我的优惠券"];
    
    [self addNoCounponView];
    [self addCounponView];
  
    [self loadData];    
}




-(void)addNoCounponView{
    _noDumpView = [[NewNoDumpView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
    [_noDumpView showViewWithType:NoTypeCounpon];
    _noDumpView.hidden = YES;
    [self.view addSubview:_noDumpView];
}

-(void)addCounponView{
    CGRect tableViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _myCounponTableView = [[SSLMyCounponTableView alloc]initWithFrame:tableViewFrame];
    _noDumpView.hidden = YES;
    [self.view addSubview:_myCounponTableView];
}


-(void)loadData{
    
    BOOL isEmptyCounpon = NO;
    
    if (isEmptyCounpon) {
        _noDumpView.hidden = NO;
        _myCounponTableView.hidden = YES;
    }else{
        _noDumpView.hidden = YES;
        _myCounponTableView.hidden = NO;
    }

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
