//
//  SSLMyCounponTableView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SSLMyCounponTableView.h"
#import "SelectTitleView.h"
@interface SSLMyCounponTableView()<UITableViewDataSource,UITableViewDelegate>
{
   SelectTitleView *_titleView;
}
@end

@implementation SSLMyCounponTableView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _couponTableView = [[UITableView alloc]init];
        [self addSubview:_couponTableView];
        
        [self showUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)addSelectSeg{
    NSArray *array = @[@"未使用(10)",@"已使用(5)"];
    CGFloat titleViewHeight = 60/2;
    _titleView = [[SelectTitleView alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth,titleViewHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.defaultIndex = 1;
    [_titleView createItem:array];
    [self addSubview:_titleView];
    

}


-(void)showUI{
    [self addSelectSeg];
    CGFloat tableView_Y = CGRectGetMaxY(_titleView.frame);
    _couponTableView.frame = CGRectMake(0, tableView_Y, self.frame.size.width, self.frame.size.height-tableView_Y);
    _couponTableView.delegate = self;
    _couponTableView.dataSource = self;
    
    [_couponTableView registerClass:[SSLCounponCell class] forCellReuseIdentifier:@"SSLCounponCell"];
  
    
    [_titleView setSelectIndexWithBlock:^(int index) {
        if (index == 0) {
            NSLog(@"未使用");
        }else if (index == 1){
            NSLog(@"已使用");
        }
    }];
}


#pragma mark TableViewDelegate  &  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{    
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSLCounponCell *cell = [SSLCounponCell cellWithTableView:_couponTableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
