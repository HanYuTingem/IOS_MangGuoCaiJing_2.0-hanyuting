//
//  BaoHeKaBaseView.m
//  LaoYiLao
//
//  Created by liujinhe on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "BaoHeKaBaseView.h"
#define DingBu_HigrtY      12
#define DingBu_WithtX      10
#define DingBu_Witht_li    kkViewWidth-2*DingBu_WithtX
#define DingBu_Higrt_li    0.83*DingBu_Witht_li
#define IPHONE4Te      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ConTenTSize  600
static  BaoHeKaViewController *baohekaVC = nil;
@interface BaoHeKaBaseView ()
@property (nonatomic,strong) UIActionSheet * sheetLivrl;//相机

@end

@implementation BaoHeKaBaseView

+ (BaoHeKaBaseView*)shareMangerWithVc:(UIViewController*)baoHeka{
    baohekaVC = baoHeka;
    static BaoHeKaBaseView *sharedBaoHeKaBaseViewInstand = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBaoHeKaBaseViewInstand = [[BaoHeKaBaseView alloc] initWithFrame:CGRectMake(0, 64, kkViewWidth, kkViewHeight-64)];
        if (IPHONE4Te) {
            sharedBaoHeKaBaseViewInstand.contentSize = CGSizeMake(320, ConTenTSize);
            sharedBaoHeKaBaseViewInstand.showsHorizontalScrollIndicator = NO;
            sharedBaoHeKaBaseViewInstand.showsVerticalScrollIndicator = NO;
        }
});
    return sharedBaoHeKaBaseViewInstand;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUI:frame];
        
    }
    return self;
}
/**基础UI*/
- (void)makeUI:(CGRect)frame{
    CGRect imageTest = CGRectMake(DingBu_WithtX, DingBu_HigrtY, DingBu_Witht_li, DingBu_Higrt_li);
    _iWmageView = [[UIImageView alloc] initWithFrame:imageTest];
    _iWmageView.image = [UIImage imageNamed:@"ljh_baoheka_bgdefault.png"];
    _iWmageView.userInteractionEnabled = YES;
    _iWmageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_iWmageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetWidth(imageTest)/2-72,1.05*CGRectGetMidY(imageTest), 143, 31);
    [button setBackgroundImage:[UIImage imageNamed:@"ljh_baoheka_bgtihuan.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClickedEs:) forControlEvents:UIControlEventTouchUpInside];
    [_iWmageView addSubview:button];
    
    CGRect texteTest = CGRectMake(0,CGRectGetMaxY(imageTest), kkViewWidth,frame.size.height-CGRectGetMaxY(imageTest));
    if (IPHONE4Te) {
        texteTest = CGRectMake(0,CGRectGetMaxY(imageTest), kkViewWidth,ConTenTSize-CGRectGetMaxY(imageTest));
        
    }
    ZHLog(@"%@",texteTest);
    _textView = [[YLLTextPutView alloc]initWithFrame:texteTest];
    [self addSubview:_textView];
}
/**
 *  初始界面
 */
- (void)turnBaseIttView{
  _iWmageView.image = [UIImage imageNamed:@"ljh_baoheka_bgdefault.png"];
   _textView.textV.text = @"";    
}
/**调用相机或相册*/
- (void)buttonClickedEs:(UIButton*)button{
    NSLog(@"相机");
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _sheetLivrl  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }else{
        _sheetLivrl = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        
    }
    _sheetLivrl.tag = 255;
    [_sheetLivrl showInView:self];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [baohekaVC presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
    
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //方法1
    UIImage *terDele = [info objectForKey:UIImagePickerControllerEditedImage];
//    CGImageRef imageRef =terDele.CGImage;
//    CGRect rectre = CGRectMake(20, 20, 50, 50);
//    CGImageRef terDele = CGImageCreateWithImageInRect(imageRef,rectre);
//    
//    UIImage*newImage = [[UIImage alloc] initWithCGImage:(__bridge CGImageRef _Nonnull)(terDele)];
//
    UIImageView * issed = [[UIImageView alloc] initWithImage:terDele];
    issed.frame = CGRectMake(0, 0, 2*DingBu_Witht_li, 2*DingBu_Witht_li);
    CGFloat gemoErg = DingBu_Witht_li - DingBu_Higrt_li;
    _endimg = [self captureView:issed frame:CGRectMake(0, gemoErg/2, 2*DingBu_Witht_li, 2*DingBu_Higrt_li)];
    self.iWmageView.image = _endimg;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //方法2
//        HCuttingVC *imageVC = [HCuttingVC Instance];
//        imageVC.editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        imageVC.delegate = self;
//        [picker presentViewController:imageVC animated:YES completion:^{
//            nil;
//        }];
    
    
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//        [baohekaVC saveImage:image withName:@"currentImage.png"];
//    
//        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//    
//        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//    
//        isFullScreen = NO;
//        [self.imageView setImage:savedImage];
//    
//        self.imageView.tag = 100;
    
}
-(void)imagedidFinishCroppingWithImage:(UIImage *)hImage{
    [baohekaVC dismissViewControllerAnimated:YES completion:nil];
     self.iWmageView.image = hImage;
    
}
/**切割图片*/
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView hiddenYLLKeyBoard];
}
@end
