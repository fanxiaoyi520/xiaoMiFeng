//
//  XMFMyAuthenticationListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMyAuthenticationListModel : NSObject

/** 认证标记 */
@property (nonatomic, copy) NSString *authenId;

/** 身份证号 */
@property (nonatomic, copy) NSString *idCardNo;

/** 认证姓名 */
@property (nonatomic, copy) NSString *realName;


/*
"id": 1,
"idCardNo": 101010101010,
"realName": "张三"
*/
@end

NS_ASSUME_NONNULL_END
