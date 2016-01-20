//
//  ZHDumplingTypeMoneyView.m
//  LaoYiLao
//
//  Created by wzh on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDumplingTypeMoneyView.h"

#define ZHDumplingTypeMoneyViewX 0 //无所谓居中
#define ZHDumplingTypeMoneyViewY 0
#define ZHDumplingTypeMoneyViewW 490 / 2  * KPercenX
#define ZHDumplingTypeMoneyViewH 160 * KPercenY


#define MoneyY 230 / 2 * KPercenY
#define MoneyW ZHDumplingTypeMoneyViewW - 80 * KPercenX
#define MoneyH 40 * KPercenY
@implementation ZHDumplingTypeMoneyView{
    UILabel *_moneyLab;
}

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(ZHDumplingTypeMoneyViewX, ZHDumplingTypeMoneyViewY, ZHDumplingTypeMoneyViewW, ZHDumplingTypeMoneyViewH);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"laojiaozi_img"];
        [self addSubview:imageView];
        
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
//        _moneyLab.backgroundColor = [UIColor blackColor];
        _moneyLab.frame = CGRectMake(0, MoneyY,MoneyW , MoneyH);
        _moneyLab.center = CGPointMake(self.frame.size.width / 2 - 5 * KPercenX, _moneyLab.center.y);
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.textColor = [UIColor whiteColor];
        _moneyLab.font = UIFontBild60;
        [imageView addSubview:_moneyLab];
        
    }
    return self;
}

- (void)setModel:(DumplingInforModel *)model{
    _moneyLab.text = [NSString stringWithFormat:@"%.2f元",[model.resultListModel.dumplingModel.prizeAmount floatValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
