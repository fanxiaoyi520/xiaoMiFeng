//
//  XMFURLSuffixString.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/2.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#ifndef XMFURLSuffixString_h
#define XMFURLSuffixString_h

#define XMFDEBUG           //本地测试环境-内网
//#define XMFRELEASE        //线上生产环境-AppStore版本


/**本地测试环境**/
#if defined(XMFDEBUG)


#define XMF_PREFIX_URL @"http://testhk.qtopay.cn/member-service"




/**线上生产环境**/
#elif defined(XMFRELEASE)

//V2.0版本地址
//#define XMF_PREFIX_URL @"https://gateway.xmfstore.com/member-services"

//V2.0版本IP地址
#define XMF_PREFIX_URL @"http://120.236.37.75:8086/member-services"


//V1.0版本地址
//#define XMF_PREFIX_URL @"https://common.sinopayonline.com/member-services"



#endif



/*-------------------宏定义分割线----------------*/


#pragma mark - ——————— 公共数据的接口集 ————————
/**
 接口名称： 国家或地区代码
 请求方式： POST方式
 接口说明： 国家或地区代码
 */
#define URL_comm_country_region_query @"/comm/country/region/query"



#pragma mark - ——————— 标准登录和注册的接口集 ————————

/**
 接口名称： 基础登录接口
 请求方式： POST方式
 接口说明： 基础登录接口，目前仅使用于邮箱登录
 */
#define URL_auth_login_basic @"/auth/login/basic"



/**
 接口名称： 手机登录接口
 请求方式： POST方式
 接口说明： 手机登录接口
 */
#define URL_auth_login_mobile @"/auth/login/mobile"



/**
 接口名称： 邮箱注册接口
 请求方式： POST方式
 接口说明： 邮箱注册接口
 */
#define URL_auth_register_email @"/auth/register/email"


/**
 接口名称： 手机注册接口
 请求方式： POST方式
 接口说明： 手机注册接口
 */
#define URL_auth_register_mobile @"/auth/register/mobile"

/**
 接口名称： 登录页面信息和控制
 请求方式： POST方式
 接口说明： 登录页面信息和控制
 */
#define URL_platform_info @"/platform/info"


#pragma mark - ——————— 第三方授权相关的接口集 ————————

/**
 接口名称： 第三方授权检查接口
 请求方式： POST方式
 接口说明： 未授权=状态值202，调用授权的相关接口；已授权=状态值200且返回对应的Token值，相当于登录
 */
#define URL_third_check @"/third/check"


/**
 接口名称： 第三方授权绑定接口
 请求方式： POST方式
 接口说明： 第三方授权绑定接口
 */
#define URL_third_bound @"/third/bound"



#pragma mark - ——————— 通行证系列操作的接口集 ————————
/**
 接口名称： 通行证绑定邮箱接口
 请求方式： POST方式
 接口说明： （前置接口：获取邮箱验证码接口）
 */
#define URL_option_bind_mail @"/option/bind/mail"


/**
 接口名称： 通行证绑定手机接口
 请求方式： POST方式
 接口说明： （前置接口：获取短信验证码接口）
 */
#define URL_option_bind_mobile @"/option/bind/mobile"



/**
 接口名称：
 基于邮箱的通行证密码重置接口
 请求方式： POST方式
 接口说明： （前置接口：获取邮箱验证码接口）
 */
#define URL_option_password_reset_mail @"/option/password/reset/mail"

/**
 接口名称： 基于手机的通行证密码重置接口
 请求方式： POST方式
 接口说明： （前置接口：获取短信验证码接口）
 */
#define URL_option_password_reset_sms @"/option/password/reset/sms"


#pragma mark - ——————— 验证码发送和校验的接口集 ————————

/**
 接口名称：
 校验绑定账户的邮箱验证码接口
 请求方式： POST方式
 接口说明：
 （适用于第三方授权绑定：返回安全验证索引和是否绑定标识）
 */
#define URL_verify_mail_oauth_check @"/verify/mail/oauth/check"


/**
 接口名称： 获取邮箱验证码接口
 请求方式： POST方式
 接口说明： 获取绑定邮箱验证码接口（适用于第三方授权绑定：不判断是否绑定，由校验接口返回判断）
 */
#define URL_verify_mail_oauth_send @"/verify/mail/oauth/send"



/**
 接口名称： 获取登录邮箱验证码接口
 请求方式： POST方式
 接口说明： （适用于登录/重置：校验是否绑定，未绑定不发送）
 */
#define URL_verify_mail_onex_send @"/verify/mail/onex/send"


/**
 接口名称： 获取更新短信验证码接口
 请求方式： POST方式
 接口说明： （适用于注册/绑定：校验是否绑定，已绑定不发送）
 */
#define URL_verify_mail_unex_send @"/verify/mail/unex/send"



/**
 接口名称： 校验授权绑定短信验证码接口
 请求方式： POST方式
 接口说明： （适用于第三方授权绑定：返回安全验证索引和是否绑定标识）
 */
#define URL_verify_sms_oauth_check @"/verify/sms/oauth/check"


/**
 接口名称： 获取授权绑定短信验证码接口
 请求方式： POST方式
 接口说明： （适用于第三方授权绑定：不判断是否绑定，由校验接口返回判断）
 */
#define URL_verify_sms_oauth_send @"/verify/sms/oauth/send"


/**
 接口名称： 获取短信验证码接口
 请求方式： POST方式
 接口说明： （适用于登录/重置；校验是否绑定，未绑定不发送）
 */
#define URL_verify_sms_onex_send @"/verify/sms/onex/send"

/**
 接口名称： 获取短信验证码接口
 请求方式： POST方式
 接口说明： （适用于注册/绑定：校验是否绑定，已绑定不发送）
 */
#define URL_verify_sms_unex_send @"/verify/sms/unex/send"


#endif /* XMFURLSuffixString_h */
