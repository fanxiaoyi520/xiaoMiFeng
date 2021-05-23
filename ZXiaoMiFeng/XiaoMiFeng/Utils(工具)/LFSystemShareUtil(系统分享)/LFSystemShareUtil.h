//
//  LFSystemShareUtil.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LFSystemShareType) {
    LFSystemShareWeChat,//微信
    LFSystemShareQQ,//腾讯QQ
    LFSystemShareSina,//新浪微博
};

typedef NS_ENUM(NSInteger, LFSystemShareState) {
    LFSystemShareStateCancel,//取消
    LFSystemShareStateDone,//完成
    LFSystemShareStateNone,//未安装
};


@interface LFSystemShareUtil : NSObject

/**
 直接分享到某平台
 
 @param type 平台
 @param controller 弹出分享界面的控制器
 @param items 可以仅分享图@[UIImage]，可以放多张；或者仅分享纯视频、音乐@[NSURL]；或者一个带文字和缩略图的网页@[NSURL,NSString,UIImage]，等等，总之把要分享的东西放到数组即可
 @param shareResult LFSystemShareState
 */
+ (void)shareWithType:(LFSystemShareType)type controller:(UIViewController *)controller andItems:(NSArray *)items completionHandler:(void(^)(LFSystemShareState state))shareResult;



/**
 通过选择平台的控制面板分享

 @param controller 弹出分享界面的控制器
 @param items 可以仅分享图@[UIImage]，可以放多张；或者仅分享纯视频、音乐@[NSURL]；或者一个带文字和缩略图的网页@[NSURL,NSString,UIImage]，等等，总之把要分享的东西放到数组即可
 @param shareResult 结果回调
 */
+ (void)shareWithController:(UIViewController *)controller andItems:(NSArray *)items completionHandler:(void(^)(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError))shareResult;

@end

NS_ASSUME_NONNULL_END
