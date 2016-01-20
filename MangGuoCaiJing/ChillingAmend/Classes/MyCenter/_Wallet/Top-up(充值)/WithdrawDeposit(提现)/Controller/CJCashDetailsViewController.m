//
//  CJCashDetailsViewController.m
//  GongYong
//
//  Created by zhaochunjing on 16-1-5.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "CJCashDetailsViewController.h"
#import "CJTopUpCellModel.h"
#import "CJTopUpdetailCell.h"

#define CELLH    42
#define CELLID   @"detailCell"

@interface CJCashDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cashDetailsTableView;
@property (weak, nonatomic) IBOutlet UIButton *cashFinshBtn;

@property (nonatomic, strong) NSMutableArray *cashDataArray;

- (IBAction)cashFinshBtnClick;

@end

@implementation CJCashDetailsViewController

- (NSMutableArray *)cashDataArray {
    if (!_cashDataArray) {
        _cashDataArray = [NSMutableArray array];
    }
    return _cashDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMakeView];
    if (self.cashTopUpModel.bankName.length) {
        [self getDataMsg];
    }
}

/** 得到数据 */
- (void)getDataMsg {
    CJTopUpCellModel *bankModel = [[CJTopUpCellModel alloc] init];
    bankModel.name = @"银行卡：";
    bankModel.content = [NSString stringWithFormat:@"%@ (尾号%@)",self.cashTopUpModel.bankName,self.cashTopUpModel.cardSn];
    [self.cashDataArray addObject:bankModel];
    CJTopUpCellModel *amountModel = [[CJTopUpCellModel alloc] init];
    amountModel.name = @"提现金额：";
    if ([self.cashTopUpModel.fees floatValue] > 0) {
        amountModel.content = [NSString stringWithFormat:@"%.2f元 (扣除手续费%.2f元)",[self.cashTopUpModel.amount floatValue],[self.cashTopUpModel.fees floatValue]];
        [self.cashDataArray addObject:amountModel];
        CJTopUpCellModel *actualAccountModel = [[CJTopUpCellModel alloc] init];
        actualAccountModel.name = @"实际到账：";
        actualAccountModel.content = [NSString stringWithFormat:@"%.2f元",[self.cashTopUpModel.amount floatValue] - [self.cashTopUpModel.fees floatValue]];
        [self.cashDataArray addObject:actualAccountModel];
    } else {
        amountModel.content = [NSString stringWithFormat:@"%.2f元",[self.cashTopUpModel.amount floatValue]];
        [self.cashDataArray addObject:amountModel];
    }
    CJTopUpCellModel *typeModel = [[CJTopUpCellModel alloc] init];
    typeModel.name = @"提现状态：";
    switch ([self.cashTopUpModel.status intValue]) {
        case 0:
            typeModel.content = @"失败";
            break;
        case 1:
            typeModel.content = @"成功";
//            self.cashDetailsTableView.tableFooterView = [self makeTableFooterView];
            break;
        case 2:
            typeModel.content = @"关闭";
            break;
        case 3:
            typeModel.content = @"处理中";
            self.cashDetailsTableView.tableFooterView = [self makeTableFooterView];
            break;
            
        default:
            break;
    }
    [self.cashDataArray addObject:typeModel];
    [self.cashDetailsTableView reloadData];
    
}

/** 初始化页面 */
- (void)initMakeView {
    self.mallTitleLabel.text = @"提现详情";
    self.cashFinshBtn.layer.masksToBounds = YES;
    self.cashFinshBtn.layer.cornerRadius = 5;
    
    self.cashDetailsTableView.scrollEnabled = NO;
    self.cashDetailsTableView.allowsSelection = NO;
    self.cashDetailsTableView.bounces = YES;
//    self.cashDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.cashDetailsTableView registerNib:[UINib nibWithNibName:@"CJTopUpdetailCell" bundle:nil] forCellReuseIdentifier:CELLID];
}

- (UILabel *)makeTableFooterView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth - 16, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = [NSString stringWithFormat:@"提现申请成功！将在%@",self.txTemplate3];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLH;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cashDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJTopUpdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.cellModel = self.cashDataArray[indexPath.section];
    cell.contentLocation = ContentLocationRight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (IBAction)cashFinshBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
