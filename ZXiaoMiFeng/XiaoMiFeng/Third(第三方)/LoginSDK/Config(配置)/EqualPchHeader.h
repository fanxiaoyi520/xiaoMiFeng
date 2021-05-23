//
//  EqualPchHeader.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/27.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#ifndef EqualPchHeader_h
#define EqualPchHeader_h


#pragma mark - ——————— 第三方头文件和宏定义(本应放到AppDelegate里) ————————
//谷歌配置
#import <Firebase.h>
#import <GoogleSignIn/GoogleSignIn.h>


//脸书配置
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define kFacebookAppID  @"939612749844666"//脸书：应用程式编号


//微信配置
#import "WXApi.h"

#define APP_ID @"wx53a612d04b9e1a22"
#define UNIVERSAL_LINK @"https://www.bmall.com.hk/.well-known/apple-app-site-association/"



#pragma mark - ——————— 工具 ————————
#import "UtilsMacros.h"//宏定义
#import "XMFURLSuffixString.h"//接口地址宏定义
#import "XMFNetworking.h"//网络请求工具
#import "UIView+FrameCategory.h"//UIView的分类
#import "UILabel+YBAttributeTextTapAction.h"//UIlabel文本可点击
#import "UIView+GFCorner.h"//切圆角
#import "UIView+GFBorder.h"//加边框
#import "DateUtils.h"//时间日期工具
#import "XMFCommonManager.h"//全局配置
#import "UIView+Toast.h"//提示语
#import "UIView+XMFToast.h"//提示语的封装
#import "NSDictionary+NullObject.h"//判断字段是否为空
#import "NSString+Verify.h"//文字校验
#import "LimitInput.h"//限制输入
#import "UIButton+XMFImageTitlePosition.h"//按钮文字图片位置设置


#pragma mark - ——————— 控制器 ————————
#import "XMFBaseViewController.h"//基类控制器
#import "XMFBaseNavigationController.h"//导航控制器
#import "XMFResponseObjectModel.h"//返回数据归类model
#import "YYModel.h"//数据模型工具
#import "LYEmptyViewHeader.h"//占位图
#import "XMFAlertController.h"//继承性弹框
#import "IQKeyboardManager.h"//键盘处理

#import <JXTAlertManager/JXTAlertManagerHeader.h>//弹框
#import "XMFPlatformInfoModel.h"//登录页平台信息



#pragma mark - ——————— 通知名称 ————————

#define KPost_LoginSDK_Notice_LoginStatusChange @"LoginSDK_Notice_LoginStatusChange"


#endif /* EqualPchHeader_h */
