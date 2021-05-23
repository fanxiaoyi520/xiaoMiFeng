//
//  XMFUserModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMFUserInfoModel.h"


NS_ASSUME_NONNULL_BEGIN

//皮肤类型
typedef enum : NSUInteger {
    standard,
    simple,
} skinType;

@interface XMFUserModel : NSObject

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *tokenExpire;

//@property (nonatomic, strong) XMFUserInfoModel *userInfo;

//登录接口返回的信息
@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *nickName;

//个人信息接口返回的信息
@property (nonatomic, copy) NSString *agentNo;

@property (nonatomic, copy) NSString *birthDay;

@property (nonatomic, copy) NSString *gender;


//2.0版本个人信息接口返回
@property (nonatomic, copy) NSString *userGender;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNikeName;
@property (nonatomic, copy) NSString *userBirthday;


//2.0版本个人信息接口返回
@property (nonatomic, assign) skinType skinType;


@end



NS_ASSUME_NONNULL_END
