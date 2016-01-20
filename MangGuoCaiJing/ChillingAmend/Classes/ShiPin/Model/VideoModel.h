//
//  VideoModel.h
//  playerSDK
//
//  Created by zuoxiong on 15/8/26.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
/** 视频的URL地址 */
@property(nonatomic, copy) NSString *spurl;
/** 视频的id */
@property(nonatomic, copy) NSString *videoId;
/** 视频标题 */
@property(nonatomic,copy) NSString *sptitle;
/** 视频描述 */
@property(nonatomic,copy) NSString *admsg;
/** 视频添加时间 */
@property(nonatomic,copy)NSString *addtime;
/** 视屏的点击次数 */
@property(nonatomic, copy) NSString *tapCount;
/** 视频前置的图片 */
@property(nonatomic,copy) NSString *spimg;

@end


