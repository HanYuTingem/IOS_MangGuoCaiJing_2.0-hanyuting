//
//  HCuttingVC.m
//  HImageCutting
//
//  Created by 李祖浩 on 14-5-15.
//  Copyright (c) 2014年 李祖浩. All rights reserved.
//

#import "HCuttingVC.h"
#define HHBorderHigh 110
@interface HCuttingVC ()

@end
static HCuttingVC* transfer;
@implementation HCuttingVC
@synthesize editImage;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+ (id) Instance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (transfer == nil)
        {
            transfer = [[HCuttingVC alloc] init];
        }
    }
    return transfer;
}
+(id) allocWithZone:(NSZone *)zone{//重写allocWithZone用于确定：不能使用其他方法创建类的实例<br>
    @synchronized(self){
        if (transfer == nil) {
            transfer = [super allocWithZone:zone];
            return transfer;
        }
    }
    return nil;//如果写成这样 return [self getInstance] 当试图创建新的实例时候，会调用到单例的方法，达到共享类的实例
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        [self Thread];
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
    
}
-(void)Thread{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    size1 = CGSizeMake(320, (320*editImage.size.height)/editImage.size.width);
    editImage = [HCuttingObject scaleToSize:CGSizeMake(editImage.size.width, editImage.size.height) image:editImage];
    
    lowimageView.frame = CGRectMake(0, HHBorderHigh, size1.width,size1.height+nextView.bounds.size.height);

    zoomImageView.image = editImage;

    heightFloat = size1.height > 360?HHBorderHigh:0;
    CGRect rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = size1.width;
    rect.size.height = size1.height;
    
    [zoomImageView setFrame:rect];
    
    [scrollView setMinimumZoomScale:[scrollView frame].size.width / [zoomImageView frame].size.width];
    
    [scrollView setZoomScale:([scrollView frame].size.width / [zoomImageView frame].size.width+0.01)];
    
    scrollView.contentSize = [lowimageView frame].size;
    scrollView.contentOffset = CGPointMake(0, heightFloat);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([HCuttingObject HimageSizeJudge:editImage] == YES) {
        [self Draw];
    }else{
        
        NSLog(@"对不起您的图片尺寸不符合规范，点击从选！");
    }
    
    // Do any additional setup after loading the view.
}
-(void)Draw{
    @try {
        
//        绘制ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-90)];
        [scrollView setBackgroundColor:[UIColor blackColor]];
        [scrollView setDelegate:self];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setMaximumZoomScale:4.0];
        
        size1 = CGSizeMake(320, (320*editImage.size.height)/editImage.size.width);
        
//    [scrollView setContentSize:CGSizeMake(321,imageView.bounds.size.height)];
        
        [[self view] addSubview:scrollView];
        
        
//        上班半透明黑边
        UIView* onView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, HHBorderHigh)];
        onView.alpha = 0.5;
        onView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:onView];
//        剪切框

        View = [[UIImageView alloc]initWithFrame:CGRectMake(0, onView.frame.origin.y+onView.bounds.size.height, self.view.bounds.size.width, (self.view.bounds.size.width*480)/640)];
        View.image = [UIImage imageNamed:@"44_xiangkuang@2x.png"];
//        View.backgroundColor = [UIColor greenColor];
        View.userInteractionEnabled = NO;
        [self.view addSubview:View];
//        下面半透明黑边

        nextView = [[UIView alloc]initWithFrame:CGRectMake(0, View.frame.origin.y+View.bounds.size.height, 320, self.view.bounds.size.height-(View.frame.origin.y+View.bounds.size.height))];
        nextView.alpha = 0.5;
        nextView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:nextView];
        
        lowimageView = [[UIView alloc]initWithFrame:CGRectMake(0, HHBorderHigh, size1.width,size1.height+nextView.bounds.size.height)];

        //        绘制显示的 图片
        zoomImageView = [[UIImageView alloc]init];
        zoomImageView.backgroundColor = [UIColor clearColor];
        zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
        [zoomImageView setAnimationRepeatCount:0];
        [zoomImageView setAnimationDuration:0];
        zoomImageView.image = editImage;
        heightFloat = size1.height > 360?HHBorderHigh:0;
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = size1.width;
        rect.size.height = size1.height;
        
        [zoomImageView setFrame:rect];
        
        [scrollView setMinimumZoomScale:1.0];
        
        [scrollView setZoomScale:([scrollView frame].size.width / [zoomImageView frame].size.width+0.01)];
        [lowimageView addSubview:zoomImageView];
        
        [scrollView addSubview:lowimageView];
        
        NSLog(@"dd:%f",nextView.bounds.size.height);
        [scrollView setContentSize:[lowimageView frame].size];
        scrollView.contentOffset = CGPointMake(0, heightFloat);
        
        
        
        
//        下边按钮
        UIView* controlsView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-90, 320, 90)];
        controlsView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:controlsView];
//        [controlsView release];
        NSArray* btnArray = [[NSArray alloc]initWithObjects:@"44_a_chongpai@2x.png",@"44_a_shiyong@2x.png", nil];
        for (int i = 0; i < 2; i++) {
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(56+(i*147), 20.5, 61, 49);
            btn1.tag = 50+i;
            [btn1 addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setImage:[UIImage imageNamed:[btnArray objectAtIndex:i]] forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [controlsView addSubview:btn1];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView1 {
//    [scrollView setContentSize:CGSizeMake([imageView frame].size.width, [imageView frame].size.height+HHBorderHigh+130)];
	return lowimageView;
}
-(void)pop:(id)sender{
    UIButton* but = (UIButton*)sender;
    @try {
        
        if (but.tag == 50) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            float zoomScale = 1 / [scrollView zoomScale];
            
            CGFloat startingPointX = [scrollView contentOffset].x * zoomScale+View.frame.origin.x*zoomScale;
            
            CGFloat startingPointY = ([scrollView contentOffset].y-HHBorderHigh)* zoomScale+View.frame.origin.y*zoomScale;
            
            CGFloat terminalX = [View bounds].size.width * zoomScale;
            
            CGFloat terminalY = [View bounds].size.height * zoomScale;
            
            [delegate imagedidFinishCroppingWithImage:[HCuttingObject HimageCutOut:editImage StartingPointX:startingPointX StartingPointY:startingPointY TerminalX:terminalX TerminalY:terminalY]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
