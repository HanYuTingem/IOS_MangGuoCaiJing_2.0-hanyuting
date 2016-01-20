//
//  WalletCouponInstructionViewController.m
//  GongYong
//
//  Created by GDH on 16/1/7.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "WalletCouponInstructionViewController.h"

@interface WalletCouponInstructionViewController ()
/** 说明文字 */
@property (nonatomic, strong)  UILabel *instructLabel;

@property (nonatomic, strong) UIScrollView *couponInfoInstructionSc;
/** 解释权 */
@property (nonatomic, strong)  UILabel *explainlabel;

@end

@implementation WalletCouponInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mallTitleLabel.text = @"说明";
    [self.view addSubview:self.couponInfoInstructionSc];
    [self.couponInfoInstructionSc addSubview:self.instructLabel];
    [self.couponInfoInstructionSc addSubview:self.explainlabel];
    [self instructionRequest];
}



-(UIScrollView *)couponInfoInstructionSc{
    if (_couponInfoInstructionSc== nil) {
        _couponInfoInstructionSc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, kkViewWidth, kkViewHeight - 85)];
        //        _couponInfoScrollView.backgroundColor = [UIColor redColor];
        _couponInfoInstructionSc.userInteractionEnabled = YES;
    }
    return _couponInfoInstructionSc;
}
-(UILabel *)instructLabel{
    if (_instructLabel == nil) {
        _instructLabel = [[UILabel alloc] init];
        _instructLabel.textAlignment = NSTextAlignmentLeft;
        _instructLabel.font = [UIFont systemFontOfSize:14];
        _instructLabel.numberOfLines = 0;
//                _instructLabel.backgroundColor = [UIColor yellowColor];
        _instructLabel.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
    }
    return _instructLabel;
}


-(UILabel *)explainlabel{
    if (_explainlabel == nil) {
        _explainlabel = [[UILabel alloc] init];
        _explainlabel.textAlignment = NSTextAlignmentLeft;
        _explainlabel.font = [UIFont systemFontOfSize:14];
        _explainlabel.numberOfLines = 0;
        _explainlabel.textColor = [UIColor redColor];
//        _explainlabel.backgroundColor = [UIColor blackColor];
    }
    return _explainlabel;
}

-(void)instructionRequest{

    
    [SINOAFNetWorking postCouponWithBaseURL:WalletHttp_Coupon_instruction_URL controller:self params:nil success:^(id json) {
        
        self.instructLabel.text = json[@"couponDesc"];
        self.explainlabel.text = json[@"couponInfo"];
        NSLog(@"%@",json);
        self.instructLabel.frame = CGRectMake(20, 0, kkViewWidth - 40, [self widthOfString:json[@"couponDesc"] withFont:14 andCGFloat:kkViewWidth - 40].height);
            self.explainlabel.frame = CGRectMake(20, CGRectGetHeight(self.instructLabel.frame), kkViewWidth - 40, [self widthOfString:json[@"couponInfo"] withFont:14 andCGFloat:kkViewWidth - 40].height);
        self.couponInfoInstructionSc.contentSize = CGSizeMake(self.instructLabel.frame.size.width, self.instructLabel.size.height+ 50);
    } failure:^(NSError *error) {
        
    } noNet:^{
        
    }];
}

- (void)makeUI{
    
    //
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    


    
}
//String宽度
- (CGSize)widthOfString:(NSString *)string withFont:(int)font andCGFloat:(CGFloat)width{
    //    CGSize labsize = [string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(275, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                           context:nil];
    
    CGSize size = textRect.size;
    
    return size;
}
@end
