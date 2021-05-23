//
//  XMFUserInfoModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFUserInfoModel : NSObject

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *nickName;

@end

/**

userInfo =         {
           avatarUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/paH8IRaNpyDD9b64vvFeNzfLL37IPvA9w1qnJxevhuPI8LPTzKXESudgmFs5Tnf8WUDCY7HWWYtcoPD8522zgg/132";
           nickName = "小蜜蜂";
       }
*/

NS_ASSUME_NONNULL_END
