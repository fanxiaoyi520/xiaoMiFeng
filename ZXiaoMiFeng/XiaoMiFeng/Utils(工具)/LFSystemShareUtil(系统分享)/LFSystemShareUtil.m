//
//  LFSystemShareUtil.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "LFSystemShareUtil.h"

@implementation LFSystemShareUtil

+ (void)shareWithType:(LFSystemShareType)type controller:(UIViewController *)controller andItems:(NSArray *)items completionHandler:(void(^)(LFSystemShareState state))shareResult {
    NSString *serviceType = @"";
    switch (type){
        case LFSystemShareWeChat:
            serviceType = @"com.tencent.xin.sharetimeline";
            break;
        case LFSystemShareQQ:
            serviceType = @"com.tencent.mqq.ShareExtension";
            break;
        case LFSystemShareSina:
            serviceType = @"com.apple.share.SinaWeibo.post";
            break;
        default:
            break;
    }
    
    /*
     <NSExtension: 0x1741735c0> {id = com.apple.share.Flickr.post}",
     "<NSExtension: 0x174173740> {id = com.taobao.taobao4iphone.ShareExtension}",
     "<NSExtension: 0x174173a40> {id = com.apple.reminders.RemindersEditorExtension}",
     "<NSExtension: 0x174173bc0> {id = com.apple.share.Vimeo.post}",
     "<NSExtension: 0x174173ec0> {id = com.apple.share.Twitter.post}",
     "<NSExtension: 0x174174040> {id = com.apple.mobileslideshow.StreamShareService}",
     "<NSExtension: 0x1741741c0> {id = com.apple.Health.HealthShareExtension}",
     "<NSExtension: 0x1741744c0> {id = com.apple.mobilenotes.SharingExtension}",
     "<NSExtension: 0x174174640> {id = com.alipay.iphoneclient.ExtensionSchemeShare}",
     "<NSExtension: 0x174174880> {id = com.apple.share.Facebook.post}",
     "<NSExtension: 0x174174a00> {id = com.apple.share.TencentWeibo.post}
     */
    
    /*
     "<NSExtension: 0x174174340> {id = com.tencent.xin.sharetimeline}", //微信
     "<NSExtension: 0x174173d40> {id = com.tencent.mqq.ShareExtension}", //QQ
     "<NSExtension: 0x1741738c0> {id = com.apple.share.SinaWeibo.post}", //微博
     */
    
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        for ( id obj in items){
            if ([obj isKindOfClass:[UIImage class]]){
                [composeVC addImage:(UIImage *)obj];
            }else if ([obj isKindOfClass:[NSURL class]]){
                [composeVC addURL:(NSURL *)obj];
            } else if ([obj isKindOfClass:[NSString class]]) {
                [composeVC setInitialText:(NSString *)obj];
            }
        }
        
        // 弹出分享控制器
        composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
            if (shareResult) {
                shareResult((LFSystemShareState)result);
            }
        };
        [controller presentViewController:composeVC animated:YES completion:nil];
    } else {
        if (shareResult) {
            shareResult(LFSystemShareStateNone);
        }
    }
}

+ (void)shareWithController:(UIViewController *)controller andItems:(NSArray *)items completionHandler:(void(^)(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError))shareResult {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    activityVC.completionWithItemsHandler = shareResult;
    [controller presentViewController:activityVC animated:YES completion:nil];
}

@end
