//
//  XMFUserManager.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFUserManager.h"

#define userInfoKey  @"userInfo"

//在.m文件中添加
@interface  XMFUserManager()

@property(nonatomic,strong) YYCache *userCache;//YYCache对象

@property(nonatomic,strong) NSMutableDictionary *userInfoDict;//用户信息字典


@end

@implementation XMFUserManager


#pragma mark - 假懒加载
- (NSMutableDictionary *)userInfoDict {
    if (!_userInfoDict) {
        id value = [self.userCache objectForKey:userInfoKey];
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)value];
        return userInfoDict;
    }
    return _userInfoDict;
}

- (XMFUserModel *)userModel {
    if (!_userModel) {
        if (self.userInfoDict) {
//            XMFUserModel *employeeModel = [UserModel mj_objectWithKeyValues:self.userInfoDict];
            XMFUserModel *employeeModel = [XMFUserModel yy_modelWithDictionary:self.userInfoDict];
            
            
        
            return employeeModel;
            
        }
        
    }
    return _userModel;
}

#pragma mark - 单例 - 创建管理对象
+ (instancetype)shareManager {
    static XMFUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMFUserManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        self.userCache = [[YYCache alloc] initWithName:@"app.userInfo"];
    }
    return self;
}

#pragma mark - 存储用户字典数据
- (void)updateUserInfo:(id)userInfo {
    
    [self.userCache setObject:userInfo forKey:userInfoKey];
}

#pragma mark - 更改用户属性值
- (void)updateValue:(id)value forKey:(NSString *)key{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.userInfoDict];
    
    [tempDic setValue:value forKey:key];
    
    [self updateUserInfo:tempDic];
}



#pragma mark - 清除用户信息
-(void)removeUserInfo{
    
    [self.userCache removeObjectForKey:userInfoKey];
    
}

#pragma mark - 是否存在用户信息
-(BOOL)isContainsUserInfo{
    
    //判断缓存是否存在
    if ([self.userCache containsObjectForKey:userInfoKey]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}


@end
