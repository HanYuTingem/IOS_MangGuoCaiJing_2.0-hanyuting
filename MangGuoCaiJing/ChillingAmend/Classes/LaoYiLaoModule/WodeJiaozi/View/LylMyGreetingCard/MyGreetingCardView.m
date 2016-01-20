//
//  MyGreetingCardView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "MyGreetingCardView.h"
#import "WobaoCardResultModel.h"
#import "WobaoCardModel.h"

@interface MyGreetingCardView ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView  * _labelView;
    UILabel * _label1;
    UILabel * _label2;
    NSDictionary * _receveJson;
    int _page;
}
@property (nonatomic, strong)NSMutableArray *middleMutableArray;
@property (nonatomic, strong)NSMutableArray *receiveDataArray;
@end

@implementation MyGreetingCardView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _receveJson = [NSDictionary dictionary];
        _cardTableView = [[UITableView alloc]init];
        [self addSubview:_cardTableView];
        
        _labelView = [[UIView alloc]init];
        [self addSubview:_labelView];
        
        _page = 1;
        self.middleMutableArray = [NSMutableArray array];
        self.receiveDataArray = [NSMutableArray array];
        
        [self loadData];
        
        
        [self showUI];
        [self tableViewSepatorSet];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)loadData{
    NSString * url  =  [LYLHttpTool wobaoHekaWithSize:@"10" Page:@"1"];
    [LYLAFNetWorking postWithBaseURL:url success:^(id json) {
        NSLog(@"wobaoHeKaJson == %@",json);
    } failure:^(NSError *error) {
        
    }];
    [_cardTableView reloadData];
//    [LYLTools showHudInView:self hint:@"正在加载"];
//    NSString * pageNo = [NSString stringWithFormat:@"%d",10];
//    int size = 1;
    [LYLAFNetWorking postWithBaseURL:url success:^(id json) {
//        [self hideHud];
        ZHLog(@"%@",json);
        
        if ([json[@"code"] isEqualToString:@"100"]) {
            NSArray *arr = json[@"resultList"];
            if (arr.count>0) {
                NSMutableArray * tempMutableArray = [NSMutableArray array];
                for (int i=0; i<arr.count; i++) {
                    WobaoCardResultModel * model = [WobaoCardResultModel getWobaoCardResultModelWithDic:arr[i]];
                    [tempMutableArray addObject:model];
                }
                
                if (_page == 1) {
                    [self.middleMutableArray removeAllObjects];
                }
                [self.middleMutableArray  addObjectsFromArray:tempMutableArray];
                
                self.receiveDataArray = [NSMutableArray arrayWithArray:self.middleMutableArray];
//                [self doneWithView:_footer];
                
            }else{
//                [self showHint:@"没有更多了"];
//                [self doneWithView:_footer];
                UILabel * v = [[UILabel alloc]initWithFrame:CGRectMake(0, 30/2, kkViewWidth, 20)];
                
                v.textAlignment = NSTextAlignmentCenter;
                v.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                v.font = UIFont24;
                UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
                [v addSubview:line];
                v.text = @"没有更多数据...";
                
                [_cardTableView setTableFooterView:v];
            }
            
            [_cardTableView reloadData];
        }
        
    } failure:^(NSError *error) {
//        [self hideHud];
    }];


}

-(void)tableViewSepatorSet{
    if ([_cardTableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [_cardTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_cardTableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        [_cardTableView setLayoutMargins:UIEdgeInsetsZero];
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
    _cardTableView.frame = CGRectMake(10, tableView_Y, self.frame.size.width-2*10, self.frame.size.height-tableView_Y);
    _cardTableView.delegate = self;
    _cardTableView.dataSource = self;
    _cardTableView.showsVerticalScrollIndicator = NO;
    _cardTableView.bounces = NO;
    [_cardTableView registerClass:[MyGreetingCardCell class] forCellReuseIdentifier:@"MyGreetingCardCell"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_cardTableView setTableFooterView:v];
}


#pragma mark TableViewDelegate  &  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WobaoCardModel * cashModel = [WobaoCardModel getWobaoCardModelWithDic:_receveJson];
    return  cashModel.resultListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGreetingCardCell *cell = [MyGreetingCardCell cellWithTableView:_cardTableView];
    WobaoCardModel * cashModel = [WobaoCardModel getWobaoCardModelWithDic:_receveJson];
    cell.resultModel = cashModel.resultListArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 100/2;
    return rowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {

        
        return _labelView;
        
    }
    return nil;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 70/2;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到贺卡
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    _label1.text = @"共包234个美图";
    _label2.text = @"贺卡饺子222个";
    
}
@end
