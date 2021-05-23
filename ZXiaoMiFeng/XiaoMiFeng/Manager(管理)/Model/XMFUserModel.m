//
//  XMFUserModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFUserModel.h"

@implementation XMFUserModel


/*
//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"userInfo" : [XMFUserInfoModel class],
            
             
             };
}
*/



//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"avatarUrl":@"userAvatar",
             
             };
}

@end
