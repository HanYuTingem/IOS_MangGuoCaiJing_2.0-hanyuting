//
//  MyGreetingCardViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "NewNoDumpView.h"
#import "MyGreetingCardView.h"

#import "WobaoGreetCardViewController.h"
#import "MyGreetingCardCell.h"

#import "ReportViewController.h"
#import "HeKaLodeController.h"


@interface WobaoGreetCardViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NewNoDumpView * _noCardView;
    MyGreetingCardView  *_greetCardView;
    
    int _page;//页
    MJRefreshHeaderView * _header;
    MJRefreshFooterView * _footer;
    
    UIView  * _labelView;
    UILabel * _label1;
    UILabel * _label2;
}

@property (nonatomic, strong) UITableView       * hekaListTableView;
@property (nonatomic, strong) NSMutableArray    * receiveDataArray;
@property (nonatomic, strong) NSMutableArray    * middleMutableArray;

@end

@implementation WobaoGreetCardViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.receiveDataArray = [NSMutableArray array];
        self.middleMutableArray = [NSMutableArray array];
        _page = 1;
        [self tableViewSepatorSet];
    }
    return self;
}

-(void)tableViewSepatorSet{
    if ([_hekaListTableView respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        [_hekaListTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_hekaListTableView respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        [_hekaListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([_hekaListTableView  respondsToSelector:@selector(setSeparatorInset:)]) {
        [_hekaListTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_hekaListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_hekaListTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigation.backgroundColor = BackRedColor;
    [self changeBarTitleWithString:@"我包贺卡"];
    [self addGreetCardView];
    [self addNoCardView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if ([self.putCardNumber isEqualToString:@"0"]) {
//        [self showNoListView];
//    }else{
        [self showBaoHekaList];
        [self requestData];
        [_hekaListTableView reloadData];
//    }
}

-(void)showNoListView{
    _labelView.hidden = YES;
    _hekaListTableView.hidden = YES;
    _noCardView.hidden = NO;
}


-(void)showBaoHekaList{
    _labelView.hidden = NO;
    _hekaListTableView.hidden = NO;
    _noCardView.hidden = YES;
}



-(void)addNoCardView{
    _noCardView = [[NewNoDumpView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
    [_noCardView showViewWithType:NoTypeBaoHeka];
    _noCardView.hidden = YES;
    [self.view addSubview:_noCardView];
}


-(void)addGreetCardView{
//    CGRect greetViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
//    _hekaListTableView = [[UITableView alloc]initWithFrame:greetViewFrame];
//    _hekaListTableView.hidden = YES;
//    [self.view addSubview:_hekaListTableView];
    _hekaListTableView = [[UITableView alloc]init];
    [self.view addSubview:_hekaListTableView];
    
    _labelView = [[UIView alloc]init];
    [self.view addSubview:_labelView];
    
    
    CGFloat labelViewH = 70/2;
    _labelView.frame = CGRectMake(0, NavgationBarHeight, kkViewWidth, labelViewH);
    _labelView.backgroundColor = RGBACOLOR(234, 234, 234, 1);
    CGFloat space   = 20;//label之间的间隔
    CGFloat label_x = 10;
    CGFloat label_w = (kkViewWidth - 2*label_x - space)/2;
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
    
    _label1.text = [NSString stringWithFormat:@"共包%d个美图",111];//[self.totalMoney floatValue]
    _label2.text = [NSString stringWithFormat:@"贺卡饺子%d个",222];//self.totalNumber
    
    
    CGFloat tableView_Y = CGRectGetMaxY(_labelView.frame);
    _hekaListTableView.frame = CGRectMake(10, tableView_Y, kkViewWidth-2*10, kkViewHeight-tableView_Y);
    _hekaListTableView.delegate = self;
    _hekaListTableView.dataSource = self;
    _hekaListTableView.showsVerticalScrollIndicator = NO;
    
    //_woBaoTableView.bounces = NO;
    UIView * v = [[UILabel alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor whiteColor];
    [_hekaListTableView setTableFooterView:v];
    
    _hekaListTableView.hidden = YES;
    _labelView.hidden = YES;
    
    [_hekaListTableView registerClass:[MyGreetingCardCell class] forCellReuseIdentifier:@"MyGreetingCardCell"];
    
    
}


-(void)requestData{    
    [self showHudInView:self.view hint:@"正在加载"];
    NSString * pageNo = [NSString stringWithFormat:@"%d",_page];
    NSString *  size = @"10";
    NSString * urlStr = [LYLHttpTool wobaoHekaWithSize:size Page:[NSString stringWithFormat:@"%@",pageNo]];
    [LYLAFNetWorking getWithBaseURL:urlStr success:^(id json) {
        [self hideHud];
        ZHLog(@"wobaoHekaJson==%@",json);
        
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
                [self doneWithView:_footer];
                
            }else{
                [self showHint:@"没有更多了"];
                [self doneWithView:_footer];
                UILabel * v = [[UILabel alloc]initWithFrame:CGRectMake(0, 30/2, kkViewWidth, 20)];
                
                v.textAlignment = NSTextAlignmentCenter;
                v.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                v.font = UIFont24;
                UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kkViewWidth, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
                [v addSubview:line];
                v.text = @"没有更多数据...";
                
                [_hekaListTableView setTableFooterView:v];
            }
            
            [_hekaListTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

#pragma mark MJRefresh
- (void)addRefresh
{
    //    _header = [MJRefreshHeaderView header];
    //    _header.scrollView = _woBaoTableView;
    //    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _hekaListTableView;
    _footer.delegate = self;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer){
        _page ++;
    }else {
        _page = 1;
        [self.receiveDataArray removeAllObjects];
    }
    
    [self requestData];
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.5];
}


- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate  &  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receiveDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     MyGreetingCardCell *cell = [MyGreetingCardCell cellWithTableView:_hekaListTableView];
    cell.resultModel = self.receiveDataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = (100/2) * ScaleForHeight;
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
    
//    //    NSLog(@"row-=%ld",(long)indexPath.row);
//    LYLaoYiLaoViewController * vc = [[LYLaoYiLaoViewController alloc]init];
//    WobaoCashResultModel * model = self.wobaoXianjinDataArray[indexPath.row];
//    if (model.status == 1) {
//        vc.dumplingStates = @"4";
//    }else if (model.status == 3) {
//        vc.dumplingStates = @"1";
//    }else if (model.status == 4) {
//        vc.dumplingStates = @"2";
//    }else if (model.status == 5) {
//        vc.dumplingStates = @"3";
//    }
//    NSLog(@"dumplingStates==%@",vc.dumplingStates);
//    vc.dumplingUserPutmoneytid  = model.dumplingUserPutmoneytid;
//    [self.navigationController pushViewController:vc animated:YES];
    
    WobaoCardResultModel * model = self.receiveDataArray[indexPath.row];
    int status = model.status;
    
    if( status == 3 ){//跳转到被举报的界面
        ReportViewController * reportVC = [[ReportViewController alloc]init];
        [self.navigationController pushViewController:reportVC animated:YES];
    }else{
        HeKaLodeController *vc = [[HeKaLodeController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
