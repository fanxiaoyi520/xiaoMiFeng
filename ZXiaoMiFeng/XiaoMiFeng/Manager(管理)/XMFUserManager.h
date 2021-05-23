//
//  XMFUserManager.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMFUserModel.h"


NS_ASSUME_NONNULL_BEGIN

@class XMFUserManager;

#define UserInfoModel [XMFUserManager shareManager].userModel
#define UserInfoManager [XMFUserManager shareManager]

@interface XMFUserManager : NSObject

// 单例
+ (instancetype)shareManager;


// 用户信息
@property (nonatomic, strong) XMFUserModel *userModel;


// 存储用户字典数据
- (void)updateUserInfo:(id)userInfo;


// 更改用户属性值
- (void)updateValue:(id)value forKey:(NSString *)key;

//清除用户缓存
-(void)removeUserInfo;

//是否存在用户信息
-(BOOL)isContainsUserInfo;




@end

NS_ASSUME_NONNULL_END
