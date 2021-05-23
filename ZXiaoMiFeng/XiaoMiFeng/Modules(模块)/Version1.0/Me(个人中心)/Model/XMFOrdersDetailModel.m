//
//  XMFOrdersDetailModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersDetailModel.h"


//订单其它信息model
@implementation XMFOrdersDetailOrderInfoModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"orderId":@"id",
             
             
             };
}



@end


//订单商品model
@implementation XMFOrdersDetailOrderGoodsModel


//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"orderGoodsId":@"id",
             
             
             };
}


@end


//订单model
@implementation XMFOrdersDetailModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"orderGoods" : [XMFOrdersDetailOrderGoodsModel class],
             
             };
}

@end
