//
//  JPCommonMacros.h
//  JiPiao
//
//  Created by pipixia on 13-9-5.
//  Copyright (c) 2013年 pipixia. All rights reserved.

#ifndef iTotemFrame_ITTCommonMacros_h
#define iTotemFrame_ITTCommonMacros_h
////////////////////////////////////////////////////////////////////////////////
#pragma mark - shortcuts

/** [NSUserDefaults standardUserDefaults] */
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions 

#define RELEASE_SAFELY(__POINTER) { if(__POINTER) {[__POINTER release]; __POINTER = nil; }}

////////////////////////////////////////////////////////////////////////////////

// 获取RGB颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HHnavigationHeight self.navigationController.navigationBar.bounds.size.height+ios7-10
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kkViewWidth [[UIScreen mainScreen] bounds].size.width
#define kkViewHeight [[UIScreen mainScreen] bounds].size.height-20

// rgb颜色转换（16进制->10进制）
/** rgb颜色转换（16进制->10进制） */
#define KKColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define CreatImage(imagePath) [UIImage imageNamed:imagePath]

/** 判断版本号码 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //判断版本号码

#define ScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕的宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height//屏幕的高度

#define navHeight backView.bounds.size.height

#pragma mark - iPhone5

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //判读是否是640*1136的屏幕
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断字段时候为空的情况 不为空转换为字符串 */
#define IfNullToString(x)  ([(x) isEqual:[NSNull null]]||(x)==nil)?@"":TEXTString(x) //判断字段时候为空的情况
/** 转换为字符串 */
#define TEXTString(x) [NSString stringWithFormat:@"%@",x]  //转换为字符串

#define SCREEN_SIZE  [UIScreen mainScreen].bounds.size

#define ORIGIN_X(o_x) o_x.frame.origin.x       //x
#define ORIGIN_Y(o_y) o_y.frame.origin.y       //y
#define FRAMNE_W(f_w) f_w.frame.size.width     //width
#define FRAMNE_H(f_h) f_h.frame.size.height    //height

/** AppDelegate */
#define g_App ((AppDelegate*)[[UIApplication sharedApplication] delegate])
/** @"[" */
#define FACE_NAME_HEAD  @"["
/** @"]" */
#define FACE_NME_LAST   @"]"


/** 一个图片的宽度  30*/
#define KFacialSizeWidth    30//一个图片的宽度
/**  30//一个图片的高度 */
#define KFacialSizeHeight   30//一个图片的高度
/** 8 //一个字符的宽度 */
#define KCharacterWidth     8 //一个字符的宽度

/** 30//view */
#define VIEW_LINE_HEIGHT    30//view
/** 16//view左边的距离 */
#define VIEW_LEFT           16//view左边的距离
/** 16//view的右边的距离 */
#define VIEW_RIGHT          16//view的右边的距离
/** 8  //view的顶部距离 */
#define VIEW_TOP            8  //view的顶部距离

/** 166 //view的最大宽度 */
#define VIEW_WIDTH_MAX      166 //view的最大宽度


/** 70 */
#define MSG_CELL_MIN_HEIGHT 70
/** 32 */
#define MSG_VIEW_MIN_HEIGHT 32

// 表情转义字符的长度（ /占1个长度 2文字占两个 ）
/** 表情转义字符的长度（ /占1个长度 2文字占两个 ） */
#define FACE_NAME_LEN   4

/** 260 //设置键盘的弹出框高度 */
#define PARENT_HEIGHT 260 //设置键盘的弹出框高度
/** 44  //设置输入背景框的宽度 */
#define HEADER_HEIGHT 44  //设置输入背景框的宽度
/** 64 //设置输入背景框的高度 */
#define NAVBar_HEIGHT 64 //设置输入背景框的高度

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] < 7.0

////设置友盟社会化组件appkey
//#define UmengAppkey        @"5211818556240bc9ee01db2f"          //友盟社会化组件appkey
//
//#define WechatAppId        @"wxd930ea5d5a258f4f"                //微信的appID
//#define WechatAppSecret    @"db426a9829e4b49a0dcac7b4162da6b6"  //微信的AppSecret
//
//#define QQAppId            @"100424468"                         //QQ的appID
//#define QQAppSecret        @"c7394704798a158208a74ab60104f0ba"  //QQAppSecret
//
//
//#define GaodeKEY           @"f1cfc47d1b6b3262d7370ebb89f10934"
//
//
//#define APIKEY @"f1cfc47d1b6b3262d7370ebb89f10934"   //高德key




#endif
