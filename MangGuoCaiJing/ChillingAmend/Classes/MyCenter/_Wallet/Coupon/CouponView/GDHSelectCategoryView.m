//
//  GDHSelectCategoryView.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHSelectCategoryView.h"
#import "GDHSelectCategoryTableViewCell.h"
@interface GDHSelectCategoryView ()<UITableViewDataSource,UITableViewDelegate>
/** 遮罩 */
@property(nonatomic,strong) UIButton  *maskButton;

@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation GDHSelectCategoryView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.maskButton];
        [self.maskButton addSubview:self.selectTableView];
    }
    return self;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *arr = @[@"全部",@"商城券",@"代金券",@"优惠券",@"实物券"];
        for (NSString *str in arr) {
            [_dataArray addObject:str];
        }
    }
    return _dataArray;
}

-(UIButton *)maskButton{
    if (_maskButton == nil) {
        _maskButton = [UIButton buttonWithType: UIButtonTypeCustom];

        [_maskButton addTarget:self action:@selector(maskButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskButton;
}
-(UITableView *)selectTableView{
    if (_selectTableView == nil) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, kkViewWidth, 200) style:UITableViewStylePlain];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.backgroundColor = walletCouponBackgroundColor;
    }
    return _selectTableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    GDHSelectCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GDHSelectCategoryTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectNameText.text = self.dataArray[indexPath.row];
    cell.arrowImageView.image = [UIImage imageNamed:@"Wallet_youhuijuan_xuanze"];
    cell.arrowImageView.hidden =  YES;
    cell.tag = 1000+indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        GDHSelectCategoryTableViewCell *cell = (GDHSelectCategoryTableViewCell *)[self  viewWithTag:1000+i];
        cell.arrowImageView.hidden = YES;
    }
    GDHSelectCategoryTableViewCell *cell = (GDHSelectCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.arrowImageView.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(GDHSelectCategoryViewSelectCategory:)]) {
        [self.delegate GDHSelectCategoryViewSelectCategory:self.dataArray[indexPath.row]];
    }
    
}

-(void)maskButtonDown:(UIButton *)maskButton{
    NSLog(@"遮罩被点击");
    if ([self.delegate respondsToSelector:@selector(GDHSelectCategoryViewMaskButtonDown:)]) {
        [self.delegate GDHSelectCategoryViewMaskButtonDown:maskButton];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
        _maskButton.frame = CGRectMake(0, 0, kkViewWidth, self.frame.size.height);
}

+(instancetype)selectCategoryView{
    return [[self alloc] init];
}
@end
