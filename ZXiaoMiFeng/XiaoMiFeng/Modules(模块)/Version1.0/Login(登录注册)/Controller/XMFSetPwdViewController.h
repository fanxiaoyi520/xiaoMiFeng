//
//  XMFSetPwdViewController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    forgetPwdSetPwd,//忘记密码
    resetPwd,//重置密码
    registerSetPwd,//注册
} setPwdType;

@interface XMFSetPwdViewController : XMFBaseViewController

@property (nonatomic, assign) setPwdType pwdType;

//自定义init方法
-(instancetype)initWithType:(setPwdType)pwdType;


//验证码
@property (nonatomic, copy) NSString *codeStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;

//手机号
@property (nonatomic, copy) NSString *phoneStr;



@end

NS_ASSUME_NONNULL_END
