//
//  ZHDumplingTypeBlessingView.m
//  LaoYiLao
//
//  Created by wzh on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDumplingTypeBlessingView.h"
#define ZHDumplingTypeBlessingViewX 0 //无所谓居中
#define ZHDumplingTypeBlessingViewY 0
#define ZHDumplingTypeBlessingViewW kkViewWidth - 60 * KPercenX
#define ZHDumplingTypeBlessingViewH 175 / 2 * KPercenY

#define ContentLabX 20 * KPercenX
#define ContentLabY 10 * KPercenY
#define ContentLabW ZHDumplingTypeBlessingViewW - 2 * ContentLabX
#define ContentLabH 30 * KPercenY
@implementation ZHDumplingTypeBlessingView{
    UILabel *_contentLab;
}

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(ZHDumplingTypeBlessingViewX, ZHDumplingTypeBlessingViewY, ZHDumplingTypeBlessingViewW, ZHDumplingTypeBlessingViewH);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"laozhufu_img"];
        [self addSubview:imageView];
        
        _contentLab = [[UILabel alloc]init];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:_contentLab];
    }
    return self;
}

- (void)setModel:(DumplingInforModel *)model{
    _model = model;
//    _contentLab.text = model.resultListModel.dumplingModel.prizeInfo;
    if(IsStrWithNUll(model.resultListModel.dumplingModel.prizeInfo)){
        model.resultListModel.dumplingModel.prizeInfo = @"新年快乐";
    }
    _contentLab.text = [NSString stringWithFormat:@"%@",model.resultListModel.dumplingModel.prizeInfo] ;
    _contentLab.font = UIFontBild30;
    //固定的宽
    CGFloat contentLabFixedW = ContentLabW;
    //根据内容计算的宽
    CGFloat contentLabW = [LYLTools boundingRectWithStrW:_contentLab.text labStrH:ContentLabH andFont:UIFontBild30];
    //根据内容计算的高
    CGFloat contentLabH = [LYLTools boundingRectWithStrH:_contentLab.text labStrW:contentLabFixedW andFont:UIFontBild30];
    
    if(contentLabW > contentLabFixedW){
        if(contentLabH > ContentLabH * 2){//高度大于两行
            _contentLab.frame = CGRectMake(ContentLabX, 0, contentLabFixedW, ContentLabH * 2);
        }else{
            _contentLab.frame = CGRectMake(ContentLabX, 0, contentLabFixedW,contentLabH);
        }
    }else{
        _contentLab.frame = CGRectMake(ContentLabX, 0, contentLabW, ContentLabH);
    }
    _contentLab.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
