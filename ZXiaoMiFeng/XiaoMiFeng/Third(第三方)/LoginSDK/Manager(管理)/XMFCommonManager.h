//
//  XMFCommonManager.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/2.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CommonManager [XMFCommonManager shareManager]

//平台标识
#define PlatformCode @"platformCode"

//MD5密钥
#define MD5Key  @"MD5Key"

//账号注册类型：BSPM是企业用户，CRPM是个人用户
#define AccountType @"accountType"

//区号数组
#define AreaCodeModelArr @"areaCodeModelArr"


//登录页平台信息
#define PlatformInfoModel @"platformInfoModel"



@class XMFPlatformInfoModel;


@interface XMFCommonManager : NSObject

// 单例
+ (instancetype)shareManager;

/**
 
 MD5密钥
 
 */

//保存MD5密钥
-(void)updateMD5Key:(NSString *)key;

//获取MD5密钥
-(NSString *)getMD5Key;

//是否存在MD5密钥
-(BOOL)isContainsMD5Key;


/**
 
 平台标识
 
 */

//保存PlatformCode平台编码
-(void)updatePlatformCode:(NSString *)platformCode;

//获取PlatformCode平台编码
-(NSString *)getPlatformCode;

//是否存在PlatformCode平台编码
-(BOOL)isContainsPlatformCode;



/**
 
 账号注册类型：BSPM是企业用户，CRPM是个人用户
 
 */

//保存AccountType账号注册类型
-(void)updateAccountType:(NSString *)accountType;

//获取AccountType账号注册类型
-(NSString *)getAccountType;

//是否存在AccountType账号注册类型
-(BOOL)isContainsAccountType;



/**
 
 保存区号数组
 
 */


//保存区号数组
-(void)updateAreaModelArr:(NSMutableArray *)areaModelArr;

//获取区号数组
-(NSMutableArray *)getAreaModelArr;

//是否存在区号数组
-(BOOL)isContainsAreaModelArr;




/**
 
 保存登录页平台信息
 
 */


//保存登录页平台信息
-(void)updatePlatformInfoModel:(XMFPlatformInfoModel *)platformInfoModel;

//获取登录页平台信息
-(XMFPlatformInfoModel *)getPlatformInfoModel;

//是否存在登录页平台信息
-(BOOL)isContainsPlatformInfoModel;




//MD5加密
- (NSString *)getEntryPwdWithMD5:(NSString *)pwd;


//设置按钮不同状态不同字体方法
-(void)setButton:(UIButton *)btn titleStr:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
