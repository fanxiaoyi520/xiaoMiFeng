//
//  XMFThirdBindController.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/30.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFThirdBindController : XMFBaseViewController

//自定义创建方法：传入第三方用户信息的字典
-(instancetype)initWithDic:(NSMutableDictionary *)userInfoDic;

@end

NS_ASSUME_NONNULL_END
