//
//  NewInfoDumpView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "NewInfoDumpView.h"


#define NUMVIEW_W   self.frame.size.width   //kkViewWidth  //

@interface NewInfoDumpView ()
{
    UIView  * _numView;//饺子图片和个数view
    UIImageView *_jiaoziImgView;//饺子图片
    UILabel     *_numLabel;
    
    
    UIView  * _wolaoView;//我捞view
    UIView  * _wobaoView;//我包view
    UIView  * _showView;
    
    NSString * _modelStr;
    
//    UIImageView * _tishiImgView;
//    UILabel     * _tishiLabel;
    UIButton    * _showBtn;//炫耀一下
    
    NSMutableArray   * _wolaoNumArray;
    NSMutableArray   * _wobaoNumArray;
    
    NSArray  * _wolaoTitleArray;
    NSArray  * _wolaoImgArray;
    NSArray  * _wobaoTitleArray;
    NSArray  * _wobaoImgArray;
    
}

@property (nonatomic,strong) NSMutableArray  * wolaoBtnArray;

@end

@implementation NewInfoDumpView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(242, 242, 242, 1);
        NSLog(@"frame==%@",NSStringFromCGRect(frame));
       
        _modelStr = @"";
        self.userInteractionEnabled = YES;
        _wolaoNumArray = (NSMutableArray*)@[@"0.00元",@"0张",@"0张",@"0张"];
        _wobaoNumArray = (NSMutableArray*)@[@"0.00元",@"0张"];
        
        
        _wolaoTitleArray  =@[@"现金",@"优惠券",@"贺卡",];//@"门票"
        _wolaoImgArray = @[@"wodejiaozi_xianjin",@"wodejiaozi_youhuiquan",@"wodejiaozi_heka",@"wodejiaozi_menpiao"];
        
        _wobaoTitleArray  =@[@"现金",@"贺卡"];
        _wobaoImgArray = @[@"wodejiaozi_xianjin",@"wodejiaozi_heka"];
       
         [self initUI];
    }
    return self;
}

-(void)initUI{
    _numView    = [[UIView alloc]init];
    _wolaoView  = [[UIView alloc]init];
    _wobaoView  = [[UIView alloc]init];
    _showView   = [[UIView alloc]init];
    
    [self addSubview:_numView];
    [self addSubview:_wolaoView];
    [self addSubview:_wobaoView];
    [self addSubview:_showView];

}

-(void)showUI{
    [self addNumView];
    
    [self addWolaoView];
    
    [self addWobaoView];
    
    [self addShowView];
}

-(void)addNumView{
    _numView.backgroundColor = RGBACOLOR(192, 21, 31, 1);
    _jiaoziImgView  = [[UIImageView alloc]init];
    _numLabel       = [[UILabel alloc]init];
    [_numView addSubview:_jiaoziImgView];
    [_numView addSubview:_numLabel];
    
    CGFloat NumView_X = 0;
    CGFloat NumView_Y = 0;
    CGFloat NumView_W = NUMVIEW_W;
    CGFloat NumView_H = (316)/2 *KPercenY;
    
    _numView.frame = CGRectMake(NumView_X, NumView_Y, NumView_W, NumView_H);
    
    
    CGFloat ImgView_W = 144/2 *KPercenX;
    CGFloat ImgView_H = 144/2 *KPercenY;
    CGFloat ImgView_X = (NUMVIEW_W - ImgView_W)/2;
    CGFloat ImgView_Y = (70)/2;
    _jiaoziImgView.frame = CGRectMake(ImgView_X, ImgView_Y, ImgView_W, ImgView_H);
    _jiaoziImgView.layer.cornerRadius = ImgView_W/2;
    _jiaoziImgView.image = [UIImage imageNamed:@"wodejiaozi_default_profile"];
    _jiaoziImgView.backgroundColor = [UIColor whiteColor];
    
//    CGFloat Space_Img_label = 10;
    CGFloat Label_W = NUMVIEW_W;
    CGFloat Label_H = 36/2;
    CGFloat Label_X = 0;
    CGFloat Label_Y = _numView.frame.size.height-32/2-Label_H;//CGRectGetMaxY(_jiaoziImgView.frame) + Space_Img_label;
    _numLabel.frame = CGRectMake(Label_X, Label_Y, Label_W, Label_H);
    _numLabel.textColor = [UIColor whiteColor];
//    _numLabel.text = @"捞到72个饺子  |  包了31个饺子";
    _numLabel.textAlignment = NSTextAlignmentCenter;
    

}

-(void)addWolaoView{
    CGFloat Wolao_X = 0;
    CGFloat Wolao_Y = CGRectGetMaxY(_numView.frame)+10;
    CGFloat Wolao_W = NUMVIEW_W;
    CGFloat Wolao_H = 255/2 *KPercenY;
    _wolaoView.frame = CGRectMake(Wolao_X, Wolao_Y, Wolao_W, Wolao_H);
//    _wolaoView.backgroundColor = [UIColor whiteColor];
    
    UILabel  * _wolaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 48/2, self.frame.size.width, 12)];
    _wolaoLabel.text = @"   我捞";
    _wolaoLabel.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];//RGBACOLOR(36, 36, 36, 1);
    _wolaoLabel.font = [UIFont systemFontOfSize:12];
    [_wolaoView addSubview:_wolaoLabel];
    
    CGFloat Space_btn_btn = 0;
    NSInteger rowCount = 4;  //行 Row 列 Column
    CGFloat btnW = (NUMVIEW_W - (rowCount+1)*Space_btn_btn)/rowCount ;
    
    CGFloat btnH = 80*KPercenY;
    CGFloat Start_Y = CGRectGetMaxY(_wolaoLabel.frame)+30/2;
    CGFloat Start_X = Space_btn_btn;

    for (int i=0; i<_wolaoTitleArray.count; i++) {
        NSInteger index = i%rowCount;//一行有几个
        NSInteger page = i/rowCount;
        CGFloat btnX = index *(btnW + Space_btn_btn)+ Start_X;
        CGFloat btnY = page  *(btnH + Space_btn_btn)+ Start_Y;
        DumpBtn * button = [[DumpBtn alloc]init];
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [button dumpBtnWithCount:_wolaoNumArray[i] Img:_wolaoImgArray[i] title:_wolaoTitleArray[i]];
        [button addTarget:self action:@selector(wolaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2000 + i;
        [_wolaoView addSubview:button];
        
        if (i != 0) {
            CGRect lineFrame = CGRectMake(btnX, btnY+10, 1, btnH-40);
            UIView * lineView = [[UIView alloc]initWithFrame:lineFrame];
            lineView.backgroundColor = RGBACOLOR(235, 235, 235, 1);//[UIColor blackColor];//
            [_wolaoView addSubview:lineView];
        }
    }
}


-(void)addWobaoView{
    CGFloat Wobao_X = 0;
    CGFloat Wobao_Y = CGRectGetMaxY(_wolaoView.frame);
    CGFloat Wobao_W = NUMVIEW_W;
    CGFloat Wobao_H = 255/2*KPercenY;
    _wobaoView.frame = CGRectMake(Wobao_X, Wobao_Y, Wobao_W, Wobao_H);
//    _wobaoView.backgroundColor = [UIColor whiteColor];
    
   
    UILabel  * _wobaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 48/2, self.frame.size.width, 12)];
    _wobaoLabel.text = @"   我包";
    _wobaoLabel.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];//RGBACOLOR(36, 36, 36, 1);
    _wobaoLabel.font = [UIFont systemFontOfSize:12];
    [_wobaoView addSubview:_wobaoLabel];
    
    CGFloat Space_btn_btn = 0;
    NSInteger rowCount = 4;  //行 Row 列 Column  一行有几个
    CGFloat btnW = (NUMVIEW_W - (rowCount+1)*Space_btn_btn)/rowCount;
    
    CGFloat btnH = 80 *KPercenY;
    CGFloat Start_Y = CGRectGetMaxY(_wobaoLabel.frame)+34/2;
    
    CGFloat Start_X = Space_btn_btn;
    for (int i=0; i<_wobaoTitleArray.count; i++) {
        NSInteger index = i%rowCount;//一行有几个
        NSInteger page = i/rowCount;
        CGFloat btnX = index *(btnW + Space_btn_btn)+ Start_X;
        CGFloat btnY = page  *(btnH + Space_btn_btn)+ Start_Y;
        DumpBtn * button = [[DumpBtn alloc]init];
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [button dumpBtnWithCount:_wobaoNumArray[i] Img:_wobaoImgArray[i] title:_wobaoTitleArray[i]];
        [button addTarget:self action:@selector(wobaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 3000 + i;
        [_wobaoView addSubview:button];
        if (i != 0) {
            CGRect lineFrame = CGRectMake(btnX, btnY+10, 1, btnH-40);
            UIView * lineView = [[UIView alloc]initWithFrame:lineFrame];

            lineView.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];//RGBACOLOR(235, 235, 235, 1);//[UIColor blackColor];//
            [_wobaoView addSubview:lineView];
        }
    }
}


-(void)addShowView{
    CGFloat ShowView_X = 0;
    CGFloat ShowView_H = self.frame.size.height-CGRectGetMaxY(_wobaoView.frame);//(self.frame.size.height-_numView.frame.size.height-_wolaoView.frame.size.height-_wobaoView.frame.size.height)*KPercenY;
    CGFloat ShowView_Y = self.frame.size.height - ShowView_H; //CGRectGetMaxY(_wobaoView.frame);
    CGFloat ShowView_W = NUMVIEW_W;
    _showView.frame = CGRectMake(ShowView_X, ShowView_Y, ShowView_W, ShowView_H);
    _showView.backgroundColor = [UIColor clearColor];
    
    
//    _tishiImgView   = [[UIImageView alloc]init];
//    _tishiLabel     = [[UILabel alloc]init];
    _showBtn        = [[UIButton alloc]init];
//    [_showView addSubview:_tishiLabel];
//    [_showView addSubview:_tishiImgView];
    [_showView addSubview:_showBtn];
//    _showView.backgroundColor = [UIColor yellowColor];

    CGFloat xuanyaoW = 432/2 *KPercenX;
    CGFloat xuanyaoH = 72/2 *KPercenY;
//    CGFloat space = 45;
    CGFloat xuanyaoY = (44/2) *KPercenY;//_showView.frame.size.height-space-xuanyaoH;//_showView.frame.size.height-90/2-xuanyaoW;
    CGFloat xuanyaoX = (self.frame.size.width-xuanyaoW)/2;
//    CGFloat Space_img_btn = 20;
    _showBtn .frame = CGRectMake(xuanyaoX, xuanyaoY, xuanyaoW, xuanyaoH);
    
//    CGFloat tishiW = 10;
//    CGFloat tishiLabelW =  430/2;
//    CGFloat tishi_X = (kkViewWidth - tishiLabelW -tishiW)/2;
//    CGFloat tishi_Y = CGRectGetMaxY(_showBtn.frame)+ Space_img_btn;
//    _tishiImgView.frame = CGRectMake(tishi_X, tishi_Y, tishiW, tishiW);
    
//    _tishiLabel.frame = CGRectMake(CGRectGetMaxX(_tishiImgView.frame)+4, _tishiImgView.frame.origin.y, tishiLabelW, tishiW);
    
    
    
//    _tishiImgView.image = [UIImage  imageNamed:@"iconfont-xiaogantanhao"];
//    
//    _tishiLabel.text = @"通过活动获得的现金及优惠劵明细请到我的钱包中查询";
//    _tishiLabel.font = [UIFont systemFontOfSize:8.0f];
//    _tishiLabel.textColor = [UIColor lightGrayColor];
    
    [_showBtn setBackgroundImage:[UIImage imageNamed:@"button_xuanyao"] forState:UIControlStateNormal];
    [_showBtn setTitle:@"炫耀一下" forState:UIControlStateNormal];
    [_showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _showBtn.titleLabel.font = UIFont30;
    _showBtn.userInteractionEnabled = YES;
    [_showBtn addTarget:self action:@selector(showMyDump) forControlEvents:UIControlEventTouchUpInside];

}


-(void)setMyDumpModel:(SSMyDumplingModel *)myDumpModel{
    _myDumpModel = myDumpModel;
    
    NSString * wolaoPrice = [NSString stringWithFormat:@"%.2f元",[_myDumpModel.resultListModel.price floatValue]];
    NSString * couponNum = [NSString stringWithFormat:@"%@张",_myDumpModel.resultListModel.couponNumber];
    NSString * wolaoCard = [NSString stringWithFormat:@"%@张",_myDumpModel.resultListModel.cardNumber];
    _wolaoNumArray = [NSMutableArray arrayWithArray: @[wolaoPrice,couponNum,wolaoCard]];
    
    NSString * wobaoMoney = [NSString stringWithFormat:@"%.2f元",[_myDumpModel.resultListModel.putMoney floatValue]];
    NSString * wobaoCard = [NSString stringWithFormat:@"%@张",_myDumpModel.resultListModel.putCardNumber];
    
    _wobaoNumArray = [NSMutableArray arrayWithArray: @[wobaoMoney,wobaoCard]];

    [self showUI];
    
    for (int i=0; i<_wolaoTitleArray.count; i++) {
        [[self.wolaoBtnArray objectAtIndex:i] dumpBtnWithCount:_wolaoNumArray[i] Img:_wolaoImgArray[i] title:_wolaoTitleArray[i]];        
    }
    
    /*** 捞到多少饺子，包了多少饺子 **/
    
//    NSString * modelStr1 = _myDumpModel.resultListModel.in_count;
//    NSString * modelStr2 = _myDumpModel.resultListModel.out_count;
    
    NSString * modelStr1 = _myDumpModel.resultListModel.count;
    NSString * modelStr2 = _myDumpModel.resultListModel.putDumpNumber;
    
    _numLabel.text = [NSString stringWithFormat:@"捞到 %@个 饺子 | 包了 %@ 个饺子",modelStr1,modelStr2];
    _numLabel.font = UIFont28;
    _numLabel.textColor = [UIColor whiteColor];
    
    NSString * textStr = _numLabel.text;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: textStr];
    NSRange range = [textStr rangeOfString:modelStr1];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 0;
    NSDictionary * adic = @{NSFontAttributeName :UIFont40,NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:adic range:range];
    
    NSRange range2 = [textStr rangeOfString:modelStr2];
    NSDictionary * bdic = @{NSFontAttributeName :UIFont40,NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:bdic range:range2];
    [_numLabel setAttributedText: AttributedStr];
    
    [self layoutSubviews];
}




//-(NSArray *)wolaoBtnArray{
//
//    if (_wolaoBtnArray == nil) {
//        for (int i=0; i<_wobaoTitleArray.count; i++) {
//            DumpBtn * button = [[DumpBtn alloc]init];
//            [_wolaoBtnArray addObject:button];
//        }
//    }
//    return _wolaoBtnArray;
//}


-(void)layoutSubviews{
    [super layoutSubviews];
}


-(void)wolaoButtonClick:(DumpBtn *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wolaoBtnClicked:)]) {
        [self.delegate wolaoBtnClicked:sender];
    }
}

-(void)wobaoButtonClick:(DumpBtn *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wobaoBtnClicked:)]) {
        [self.delegate wobaoBtnClicked:sender];
    }
}


-(void)showMyDump{
    if (self.delegate && [self.delegate respondsToSelector:@selector(Xuanyaoyixia)]) {
        [self.delegate Xuanyaoyixia];
    }
}


- (void)settingLabelAttributedWithLabel:(UILabel *)label String:(NSString *)textStr modelStr:(NSString *)modelStr str2:(NSString *)str2 font1:(UIFont *)font1 font2:(UIFont *)font2 color1:(UIColor *)color1 color2:(UIColor *)color2 {
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    NSRange range = [textStr rangeOfString:modelStr];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 0;
    
    style.alignment = NSTextAlignmentCenter;
    if ([textStr containsString:modelStr]) {
        
    }
    NSDictionary * adic = @{NSFontAttributeName :font1,NSForegroundColorAttributeName:color1,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:adic range:range];
    
    NSRange range2 = [textStr rangeOfString:str2];
    NSDictionary * bdic = @{NSFontAttributeName :font2,NSForegroundColorAttributeName:color2,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:bdic range:range2];
    
    //    NSRange range3 = [textStr rangeOfString:str3];
    //    NSDictionary * cdic = @{NSFontAttributeName :font3,NSForegroundColorAttributeName:color3,NSParagraphStyleAttributeName:style};
    //    [AttributedStr addAttributes:cdic range:range3];
    [label setAttributedText: AttributedStr];
}



@end
