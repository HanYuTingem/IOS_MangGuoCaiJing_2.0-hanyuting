//
//  ZXADTableView.m
//  fanxiaoqi
//
//  Created by xiong on 15/10/27.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "ZXADTableView.h"
#import "UIView+ResponderViewController.h"


#import "ZCSTicketTableCell.h"
@interface ZXADTableView () <LMTicketTableDelegate>
/** 表格底部的灰条 */
@property (nonatomic, strong) UIView* endView;
@property (nonatomic, strong) ZCSTicketTableCell* zxCell;
@end

@implementation ZXADTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)updateTableHeight
{
    //更新高度前先重载数据
    [self.tableView reloadData];
    //根据列表长度，更新tableview的高度
    CGSize tableSize = [self.tableView sizeThatFits:CGSizeMake(self.tableView.frame.size.width, MAXFLOAT)];
    self.tableHeight.constant = tableSize.height;
    CGRect tempRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tableSize.height + 112);
    self.frame = tempRect;
}

+ (id)createADTableView
{
    return [[NSBundle mainBundle]
        loadNibNamed:@"ZXADTableView"
               owner:self
             options:nil][0];
}


#pragma mark - TableViewDelegate 代理方法
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 123;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 29;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

}

#pragma mark - UITableViewDataSource 代理方法
//段头

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ZCSTicketTableCell* zxCell = [ZCSTicketTableCell createFooterCell:tableView];
    self.zxCell = zxCell;
    zxCell.delegate = self;
    zxCell.footLine.hidden = NO;
    return zxCell;
}

#pragma mark - 普通券点击购买delegate
- (void)grabBtnClick:(LMTicketModal*)ticketModal
{

}

@end
