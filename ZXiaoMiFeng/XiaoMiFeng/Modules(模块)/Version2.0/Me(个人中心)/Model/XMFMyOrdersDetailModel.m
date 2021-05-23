//
//  XMFMyOrdersDetailModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersDetailModel.h"
#import "XMFMyOrdersListModel.h"//订单列表model



@implementation XMFMyOrdersDetailGoodsListModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end




@implementation XMFMyOrdersDetailModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"goodsList" : [XMFMyOrdersListGoodsListModel class],
        
    };
}


@end
