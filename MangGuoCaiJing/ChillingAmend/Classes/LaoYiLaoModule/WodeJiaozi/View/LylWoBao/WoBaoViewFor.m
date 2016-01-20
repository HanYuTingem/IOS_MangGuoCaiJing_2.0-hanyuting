//
//  WoBaoViewFor.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//
/*
 //
 //  NSDictionary *  json  = @{@"put_ price":@"200.00",@"number_ price":@"100",@"resultList":@[
 //                      @{@"dumpling_user_put_money_id":@"001",@"createTime":@"10:21",@"content":@"20个饺子每个5毛，饺子10元，领完10",@"dumplingMoney":@"10.00",@"dumplingNum":@"30",@"getDumplingNum":@"10",@"status":@"1",},
 //                      @{@"dumpling_user_put_money_id":@"002",@"createTime":@"10:22",@"content":@"10个饺子每个2快，饺子20元，领完10",@"dumplingMoney":@"20.00",@"dumplingNum":@"10",@"getDumplingNum":@"10",@"status":@"2",},
 //                      @{@"dumpling_user_put_money_id":@"003",@"createTime":@"10:23",@"content":@"10个饺子每个5快，饺子50元，领完8",@"dumplingMoney":@"30.00",@"dumplingNum":@"50",@"getDumplingNum":@"20",@"status":@"3",},
 //                      @{@"dumpling_user_put_money_id":@"004",@"createTime":@"10:24",@"content":@"恭喜发财,猴年大吉",@"dumplingMoney":@"40.00",@"dumplingNum":@"40",@"getDumplingNum":@"10",@"status":@"1",},
 //                      ]};
 //    _receveJson = json;
 
 */

#import "WoBaoViewFor.h"
#import "WobaoCashResultModel.h"
#import "WobaoCashModel.h"

#import "LYLaoYiLaoViewController.h"
@interface WoBaoViewFor ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView  * _labelView;
    UILabel * _label1;
    UILabel * _label2;
    
    
}
@property (nonatomic, strong) NSDictionary * receveJson;
@property (nonatomic, strong) NSMutableArray  * receveArray;
@end


@implementation WoBaoViewFor

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];//#efeff4RGBACOLOR(235, 235, 241, 1);
        
        _woBaoTableView = [[UITableView alloc]init];
        [self addSubview:_woBaoTableView];
        
        _labelView = [[UIView alloc]init];
        [self addSubview:_labelView];
        self.receveArray = [NSMutableArray array];
        
        [self tableViewSepatorSet];
        
        [self loadData];
        
        [self showUI];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)loadData{
//    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool wobaoXianjinWithSize:@"10" page:@"1"] success:^(id json) {
//        ZHLog(@"%@",json);
//        if([json[@"code"] isEqualToString:@"100"]){
//            
//            WobaoCashModel * cashModel = [WobaoCashModel getWobaoCashModelWithDic:(NSDictionary *)json];
//            self.receveArray = cashModel.cashResultArray;
//            NSLog(@"receveArray==%@",self.receveArray);
//            [self showUI];
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

-(void)tableViewSepatorSet{
    if ([_woBaoTableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [_woBaoTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_woBaoTableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        [_woBaoTableView setLayoutMargins:UIEdgeInsetsZero];        
    }
}


-(void)showUI{
    CGFloat labelViewH = 70/2;
    _labelView.frame = CGRectMake(0, 0, self.frame.size.width, labelViewH);
    _labelView.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    CGFloat space   = 20;//label之间的间隔
    CGFloat label_x = 10;
    CGFloat label_w = (self.frame.size.width - 2*label_x - space)/2;
    CGFloat label_h = 20;
    CGFloat label_y = (labelViewH-label_h)/2;
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
    _label2 = [[UILabel alloc]initWithFrame:CGRectMake(label_x+space+label_w, label_y, label_w, label_h)];
    [_labelView addSubview:_label1];
    [_labelView addSubview:_label2];
    
    _label1.textAlignment = NSTextAlignmentCenter;
    _label2.textAlignment = NSTextAlignmentCenter;
    
    _label1.backgroundColor = [UIColor clearColor];
    _label2.backgroundColor = [UIColor clearColor];
    _label1.textColor = RGBACOLOR(0, 0, 0, 1);
    _label2.textColor = RGBACOLOR(0, 0, 0, 1);
    
   
    CGFloat tableView_Y = CGRectGetMaxY(_labelView.frame);
    _woBaoTableView.frame = CGRectMake(10, tableView_Y, self.frame.size.width-2*10, self.frame.size.height-tableView_Y);
    _woBaoTableView.delegate = self;
    _woBaoTableView.dataSource = self;
    _woBaoTableView.showsVerticalScrollIndicator = NO;
    _woBaoTableView.bounces = NO;

    [_woBaoTableView registerClass:[SSWobaoCell class] forCellReuseIdentifier:@"SSWobaoCell"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_woBaoTableView setTableFooterView:v];
}
-(void)viewDidLayoutSubviews
{
    if ([_woBaoTableView  respondsToSelector:@selector(setSeparatorInset:)]) {
        [_woBaoTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_woBaoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_woBaoTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
//-(void)showViewWithType:(NSString *)wobaoViewType{
//    if ([wobaoViewType isEqualToString:WoBaoCash]){
//        _label1.text = @"共包100.00现金";
//        _label2.text = @"现金饺子100个";
//    }else if ([wobaoViewType isEqualToString:WoBaoGreetCard]){
//        _label1.text = @"共包200美图";
//        _label2.text = @"贺卡饺子200个";
//    }
//}


#pragma mark TableViewDelegate  &  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WobaoCashModel * cashModel = [WobaoCashModel getWobaoCashModelWithDic:_receveJson];
    return cashModel.cashResultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSWobaoCell *cell = [SSWobaoCell cellWithTableView:_woBaoTableView];
//    WobaoCashModel * cashModel = [WobaoCashModel getWobaoCashModelWithDic:_receveJson];
//    cell.cashResultModel = cashModel.cashResultArray[indexPath.row];
    NSLog(@"receveArray==%@",self.receveArray);
    cell.cashResultModel = self.receveArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 100/2;
    return rowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
    }
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 70/2;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"row-=%ld",(long)indexPath.row);
    LYLaoYiLaoViewController * vc = [[LYLaoYiLaoViewController alloc]init];
    [_controller.navigationController pushViewController:vc animated:YES];
}


-(void)layoutSubviews{
    [super layoutSubviews];
//    WobaoCashModel * cashModel = [WobaoCashModel getWobaoCashModelWithDic:_receveJson];
    //    _label1.text =[NSString stringWithFormat:@"共包%@现金",cashModel.put_price];
    //    _label2.text = [NSString stringWithFormat:@"现金饺子%@个",cashModel.number_price];
            _label1.text = @"共包111.00现金";
            _label2.text = @"现金饺子111个";

    
}

@end
