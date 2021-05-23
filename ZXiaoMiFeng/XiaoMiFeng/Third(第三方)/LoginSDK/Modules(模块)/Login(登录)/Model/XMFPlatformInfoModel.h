//
//  XMFPlatformInfoModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFPlatformInfoModel : NSObject<NSCoding>


@property (nonatomic, copy) NSString * accessTime;
@property (nonatomic, copy) NSString * enableAlipay;
@property (nonatomic, copy) NSString * enableApple;
@property (nonatomic, copy) NSString * enableFacebook;
@property (nonatomic, copy) NSString * enableGoogle;
@property (nonatomic, copy) NSString * enableInstagram;
@property (nonatomic, copy) NSString * enableLine;
@property (nonatomic, copy) NSString * enableQq;
@property (nonatomic, copy) NSString * enableTiktok;
@property (nonatomic, copy) NSString * enableTwitter;
@property (nonatomic, copy) NSString * enableWechat;
@property (nonatomic, copy) NSString * enableWeibo;
@property (nonatomic, copy) NSString * enableWhatsapp;
@property (nonatomic, copy) NSString * logoAlign;
@property (nonatomic, copy) NSString * logoUrl;
@property (nonatomic, copy) NSString * platformCode;
@property (nonatomic, copy) NSString * platformName;



@end

NS_ASSUME_NONNULL_END
