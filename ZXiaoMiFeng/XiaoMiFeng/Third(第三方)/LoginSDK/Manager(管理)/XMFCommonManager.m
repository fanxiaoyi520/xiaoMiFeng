//
//  XMFCommonManager.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/2.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFCommonManager.h"
#import "NSString+MD5.h"//MD5加密


@implementation XMFCommonManager

#pragma mark - 单例 - 创建管理对象
+ (instancetype)shareManager {
    static XMFCommonManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMFCommonManager alloc] init];
    });
    return instance;
}

//保存MD5密钥
-(void)updateMD5Key:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:key forKey:MD5Key];
   
    [userDefaults synchronize];
    
}

//获取MD5密钥
-(NSString *)getMD5Key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *MD5KeyStr = [userDefaults objectForKey:MD5Key];
    
    return MD5KeyStr;
}

//是否存在MD5密钥
-(BOOL)isContainsMD5Key{
    
    if ([self getMD5Key].length > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}


//保存PlatformCode平台编码
-(void)updatePlatformCode:(NSString *)platformCode{
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     
     [userDefaults setObject:platformCode forKey:PlatformCode];
    
     [userDefaults synchronize];
    
}

//获取PlatformCode平台编码
-(NSString *)getPlatformCode{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *platformCodeStr = [userDefaults objectForKey:PlatformCode];
    
    return platformCodeStr;
}

//是否存在PlatformCode平台编码
-(BOOL)isContainsPlatformCode{
    
    if ([self getPlatformCode].length > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}



//保存AccountType账号注册类型
-(void)updateAccountType:(NSString *)accountType{
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     
     [userDefaults setObject:accountType forKey:AccountType];
    
     [userDefaults synchronize];
    
}

//获取AccountType账号注册类型
-(NSString *)getAccountType{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *accountTypeStr = [userDefaults objectForKey:AccountType];
    
    return accountTypeStr;
    
}

//是否存在AccountType账号注册类型
-(BOOL)isContainsAccountType{
    
    if ([self getAccountType].length > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}


//保存区号数组
-(void)updateAreaModelArr:(NSMutableArray *)areaModelArr{
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //需要将你需要存储的数据转成data

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:areaModelArr];
     
     [userDefaults setObject:data forKey:AreaCodeModelArr];
    
     [userDefaults synchronize];
    
    
}

//获取区号数组
-(NSMutableArray *)getAreaModelArr{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    
    NSData *data = [userDefaults objectForKey:AreaCodeModelArr];

    NSMutableArray *areaModelArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return areaModelArr;
    
}

//是否存在区号数组
-(BOOL)isContainsAreaModelArr{
    
    if ([self getAreaModelArr].count > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}


//保存登录页平台信息
-(void)updatePlatformInfoModel:(XMFPlatformInfoModel *)platformInfoModel{
    
    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //需要将你需要存储的数据转成data

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:platformInfoModel];
     
     [userDefaults setObject:data forKey:PlatformInfoModel];
    
     [userDefaults synchronize];
    
    
}

//获取登录页平台信息
-(XMFPlatformInfoModel *)getPlatformInfoModel{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

      
      NSData *data = [userDefaults objectForKey:PlatformInfoModel];

     XMFPlatformInfoModel  *platformInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
      
      return platformInfoModel;
    
}

//是否存在登录页平台信息
-(BOOL)isContainsPlatformInfoModel{
    
    if ([self getPlatformInfoModel] != nil) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}




//MD5加密
- (NSString *)getEntryPwdWithMD5:(NSString *)pwd{
    
//    return [[[pwd stringByAppendingString:[self getMD5Key]] MD5String] uppercaseString];
    
    return [[pwd MD5String] uppercaseString];
}

#pragma mark - ——————— 设置按钮方法 ————————
-(void)setButton:(UIButton *)btn titleStr:(NSString *)title{
    
    //设置默认状态的文字
    NSMutableAttributedString *titleNormalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
    [titleNormalStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:15.0] range:NSMakeRange(0,titleNormalStr.length)];
    [titleNormalStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x33333) range:NSMakeRange(0,titleNormalStr.length)];
    
    [btn setAttributedTitle:titleNormalStr forState:UIControlStateNormal];
    
    //设置选中状态的文字
    NSMutableAttributedString *titleSelectedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
    //PingFangSC-Semibold   PingFangSC-Medium
    [titleSelectedStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:15.0] range:NSMakeRange(0,titleSelectedStr.length)];
    [titleSelectedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0,titleSelectedStr.length)];
    
    [btn setAttributedTitle:titleSelectedStr forState:UIControlStateSelected];

}

@end
