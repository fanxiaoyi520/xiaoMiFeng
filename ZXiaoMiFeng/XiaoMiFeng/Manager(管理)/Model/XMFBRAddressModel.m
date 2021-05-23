//
//  XMFBRAddressModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBRAddressModel.h"

@implementation XMFBRAreaModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"index":@"id"
             
             };
}

@end


@implementation XMFBRCityModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"arealist" : [XMFBRAreaModel class],
            
             
             };
}



//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"arealist":@"childs",
             
             @"index":@"id"
             
             };
}


@end



@implementation XMFBRProvinceModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"citylist" : [XMFBRCityModel class],
            
             
             };
}



//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"citylist":@"childs",
             @"index":@"id"
             
             };
}


@end



@implementation XMFBRAddressModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"provincelist" : [XMFBRProvinceModel class],
            
             
             };
}

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"provincelist":@"data",
        
             };
}



@end
