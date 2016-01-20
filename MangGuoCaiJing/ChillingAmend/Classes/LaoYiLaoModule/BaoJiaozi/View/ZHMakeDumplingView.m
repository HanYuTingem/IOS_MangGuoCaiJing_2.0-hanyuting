//
//  ZHMakeDumplings.m
//  LaoYiLao
//
//  Created by wzh on 15/12/14.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHMakeDumplingView.h"
#import "BaoHeKaViewController.h"
#import "BaoJiaoZiViewController.h"

////标题frame、
//#define TitleImageViewX 0 //无所谓居中
//#define TitleImageViewY 15 * KPercenY
//#define TitleImageViewW 242 * KPercenX
//#define TitleImageViewH 58 * KPercenY
//顶部图片
#define TopImageViewX 9 * KPercenX
#define TopImageViewY 13 * KPercenY
#define TopImageViewW kkViewWidth - 2 * TopImageViewX //+ CGRectGetMaxY(titleImageView.frame)
#define TopImageViewH 455 / 2 * KPercenY

//简介图片
#define ContentImageViewX 5 * KPercenX
#define ContentImageViewY CGRectGetMaxY(_topImageView.frame) + 2
#define ContentImageViewW kkViewWidth - 2 * ContentImageViewX
#define ContentImageViewH 61 / 2 * KPercenY

//有缘人和朋友btn的frma
#define TopSelectBtnY CGRectGetMaxY(_contentImageView.frame) + 19 * KPercenY
#define TopSelectBtnW btnW
#define TopSelectBtnH btnH

//现金的frame
#define MoneyBtnX lefAndRight - MoneyBtnW
#define MoneyBtnY TopSelectBtnY + TopSelectBtnH + 15 * KPercenY
#define MoneyBtnW 35
#define MoneyBtnH MoneyBtnW + 15

#define GreetingCardBtnX btnW +  CGRectGetMaxX(_moneyBtn.frame)
#define GreetingCardBtnY MoneyBtnY
#define GreetingCardBtnW MoneyBtnW
#define GreetingCardBtnH MoneyBtnH

@implementation ZHMakeDumplingView{

    UIImageView *_topImageView;
    UIImageView *_contentImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, NavgationBarHeight)]];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
//
//    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(TitleImageViewX, TitleImageViewY, TitleImageViewW, TitleImageViewH)];
//    titleImageView.image = [UIImage imageNamed:@"banner"];
//    titleImageView.center = CGPointMake(self.frame.size.width / 2, titleImageView.center.y);
//    [self addSubview:titleImageView];
    
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(TopImageViewX, TopImageViewY, TopImageViewW, TopImageViewH)];
    _topImageView.image = [UIImage imageNamed:@"baojiaozi-shouye-01"];
    [self addSubview:_topImageView];
    
    
    _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ContentImageViewX, ContentImageViewY, ContentImageViewW, ContentImageViewH)];
    _contentImageView.image = [UIImage imageNamed:@"baojiaozi-shouye-02"];
    [self addSubview:_contentImageView];
    
    
    NSArray *title = @[@"朋友",@"有缘人"];
    NSArray *imageName = @[@"baojiaozi-sy-py-moren",@"baojiaozi-sy-yyr-moren"];
    NSArray *highlightedImage = @[@"baojiaozi-sy-py-dianji",@"baojiaozi-sy-yyr-dianji"];
    CGFloat lefAndRight =  67 * KPercenX;
    CGFloat mid = 85 * KPercenX;
    CGFloat btnW = 50;
    CGFloat btnH = btnW + 20;
    
    for (int  i = 0; i < title.count; i ++ ) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(lefAndRight + (mid + btnW) * i, TopSelectBtnY, btnW, btnH)];
        button.titleLabel.font = UIFont28;
        [button setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:imageName[i]] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:highlightedImage[i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:highlightedImage[i]] forState:UIControlStateSelected];

        [button setTitle:title[i] forState:UIControlStateNormal];
//        button.backgroundColor = [UIColor greenColor];
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -50, -50, 0);
        button.tag = i + 100;
        button.selected = NO;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moneyBtn setFrame:CGRectMake(MoneyBtnX, MoneyBtnY, MoneyBtnW, MoneyBtnH)];
    [_moneyBtn addTarget:self action:@selector(moneyBtnCLicked:) forControlEvents:UIControlEventTouchUpInside];
    [_moneyBtn setImage:[UIImage imageNamed:@"baojiaozi-sy-pyxianjin-moren"] forState:UIControlStateNormal];
    [_moneyBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_moneyBtn setImage:[UIImage imageNamed:@"baojiaozi-sy-pyxianjin-dianji"] forState:UIControlStateHighlighted];
    [_moneyBtn setTitle:@"现金" forState:UIControlStateNormal];
    _moneyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 14, 0);
    _moneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, -40, 0);
//    _moneyBtn.backgroundColor = [UIColor greenColor];
    _moneyBtn.hidden = YES;
    _moneyBtn.titleLabel.font = UIFont20;
    [self addSubview:_moneyBtn];
    
   
    _greetingCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_greetingCardBtn setFrame:CGRectMake(GreetingCardBtnX, GreetingCardBtnY, GreetingCardBtnW, GreetingCardBtnH)];
    [_greetingCardBtn addTarget:self action:@selector(greetingCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_greetingCardBtn setImage:[UIImage imageNamed:@"baojiaozi-sy-pyhk-moren"] forState:UIControlStateNormal];
    [_greetingCardBtn setImage:[UIImage imageNamed:@"baojiaozi-sy-pyhk-dianji"] forState:UIControlStateHighlighted];
    [_greetingCardBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_greetingCardBtn setTitle:@"贺卡" forState:UIControlStateNormal];
    _greetingCardBtn.titleLabel.font = UIFont22;
    _greetingCardBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 14, 0);
    _greetingCardBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, -40, 0);
    _greetingCardBtn.hidden = YES;
//    _greetingCardBtn.backgroundColor = [UIColor greenColor];
    [self addSubview:_greetingCardBtn];
}

#pragma mark --  朋友和有缘人的按钮点击
- (void)buttonClicked:(UIButton *)button{
    self.selecetButton = button;
    button.selected = !button.selected;
    if(button.tag == 100){
        ZHLog(@"点击了朋友");
        ((UIButton *)[self viewWithTag:101]).selected = NO;
        _greetingCardBtn.hidden = !_greetingCardBtn.hidden;
        _moneyBtn.hidden = !_moneyBtn.hidden;
        if(!_greetingCardBtn.hidden && !_moneyBtn.hidden){
            button.userInteractionEnabled = NO;
            [self addAnimationWith:_greetingCardBtn];
            [self addAnimationWith:_moneyBtn];
        }
    }else if (button.tag == 101){
        ZHLog(@"点击了有缘人");
        ((UIButton *)[self viewWithTag:100]).selected = NO;
        _greetingCardBtn.hidden = YES;
        _moneyBtn.hidden = YES;

        [LYLTools showHint:@"功能在路上，敬请期待！"];
//        BaoHeKaViewController * heDumpling = [[BaoHeKaViewController alloc]init];
//        heDumpling.baoHeKaLaitap = 1;
//        [[BaoHeKaBaseView shareMangerWithVc:heDumpling] turnBaseIttView];
//        [_viewController.navigationController pushViewController:heDumpling animated:YES];
    }
}

#pragma mark -- 现金的点击事件
- (void)moneyBtnCLicked:(UIButton *)button{
    ZHLog(@"点击了现金");
    
    //包现金
    BaoJiaoZiViewController * baoDumpling = [[BaoJiaoZiViewController alloc]init];
    [_viewController.navigationController pushViewController:baoDumpling animated:YES];
}
#pragma mark -- 贺卡的点击事件
- (void)greetingCardBtnClicked:(UIButton *)button{
    ZHLog(@"点击了贺卡");
    //包贺卡
    [LYLTools showHint:@"功能在路上，敬请期待！"];
    
//    BaoHeKaViewController * heDumpling = [[BaoHeKaViewController alloc]init];
//    heDumpling.baoHeKaLaitap = 0;
//    [[BaoHeKaBaseView shareMangerWithVc:heDumpling] turnBaseIttView];
//    [_viewController.navigationController pushViewController:heDumpling animated:YES];
    
}

- (void)addAnimationWith:(UIView *)objectView{
    // CAKeyframeAnimation则可以支撑随便率性多个关键帧，关键帧有两种体式格式来指定：应用path或者应用values path是一个CGPathRef的值，且path只能对CALayer的anchorPoint和position属性起感化，且设置了path之后values就不起感化了。而values更灵活
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.delegate = self;
    [objectView.layer addAnimation:animation forKey:nil];
    
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    UIButton *button =  [self viewWithTag:100];//朋友的按钮
    button.userInteractionEnabled = YES;
}
@end
