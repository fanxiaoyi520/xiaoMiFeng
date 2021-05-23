//
//  XMFLoginController.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/27.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

#define appId @"wx53a612d04b9e1a22" //填入微信申请的APP的appid
#define appSecret @"9bca26ee81e77b53e5a40281227de3d8" //填入微信申请的APP的appSecret
#define WX_ZONE_ID @"wxb260e832ebcdeed8" //填入微信开放平台的appid代码(注意区分上面的appid)

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"


#define APPLE_APPLE_ID @"1516567999"//从苹果开发者账号APP信息里面复制

#define APPLE_TEAM_ID @"4787RY9G47"//从苹果开发者账号Membership里复制Team ID


@interface XMFLoginController : XMFBaseViewController

//自定义方法
-(instancetype)initWithDic:(NSDictionary *)mustParamsDic;

/** 返回block */
@property (nonatomic, copy) void (^backBlock)(void);


@end

NS_ASSUME_NONNULL_END
