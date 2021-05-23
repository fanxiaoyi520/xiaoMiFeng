//
//  XMFHomeGoodsPropertyModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsPropertyModel.h"


@implementation XMFHomeGoodsPropertyProductsModel



@end






@implementation  XMFHomeGoodsPropertySpecificationsValuesModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"specificationId":@"id",
             
             
             };
}

@end






@implementation XMFHomeGoodsPropertySpecificationsModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"goodsSpecificationValues" : [XMFHomeGoodsPropertySpecificationsValuesModel class]
       
             };
}

@end





@implementation XMFHomeGoodsPropertyModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"goodsProducts" : [XMFHomeGoodsPropertyProductsModel class],
        
        @"goodsSpecifications" : [XMFHomeGoodsPropertySpecificationsModel class]
       
             };
}

@end
